const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");
require("dotenv").config();

const app = express();

app.use(cors());
app.use(express.json());

// PostgreSQL connection
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

// Home route
app.get("/", (req, res) => {
  res.send("TaskFlow API is running!");
});

// Get all tasks
app.get("/tasks", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM tasks ORDER BY id ASC"
    );

    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({
      error: "Database error",
    });
  }
});

// Add a task
app.post("/tasks", async (req, res) => {
  try {
    const { title } = req.body;

    const result = await pool.query(
      "INSERT INTO tasks(title) VALUES($1) RETURNING *",
      [title]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({
      error: "Database error",
    });
  }
});

// Mark task as completed
app.put("/tasks/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `UPDATE tasks
       SET completed = true
       WHERE id = $1
       RETURNING *`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: "Task not found",
      });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({
      error: "Database error",
    });
  }
});

// Delete a task
app.delete("/tasks/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      "DELETE FROM tasks WHERE id = $1 RETURNING *",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: "Task not found",
      });
    }

    res.json(result.rows[0]);

  } catch (err) {
    console.error(err);

    res.status(500).json({
      error: "Database error",
    });
  }
});
app.listen(5000, () => {
  console.log("Server running on http://localhost:5000");
});
