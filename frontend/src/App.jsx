import { useEffect, useState } from "react";

function App() {
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState("");

  const loadTasks = async () => {
    const res = await fetch("/tasks");
    const data = await res.json();
    setTasks(data);
  };

  useEffect(() => {
    loadTasks();
  }, []);

  const addTask = async () => {
    if (title.trim() === "") return;

    await fetch("/tasks", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ title }),
    });

    setTitle("");
    loadTasks();
  };
const completeTask = async (id) => {
  await fetch(`/tasks/${id}`, {
    method: "PUT",
  });

  loadTasks();
};

const deleteTask = async (id) => {
  await fetch(`/tasks/${id}`, {
    method: "DELETE",
  });

  loadTasks();
};

  return (
    <div style={{ padding: "20px" }}>
      <h1>TaskFlow</h1>

      <input
        type="text"
        placeholder="Enter a task"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
      />

      <button onClick={addTask}>Add Task</button>

      <h2>My Tasks</h2>

<ul>
  {tasks.map((task) => (
    <li key={task.id}>
      {task.completed ? "✅" : "⬜"} {task.title}

      {!task.completed && (
        <button onClick={() => completeTask(task.id)}>
          Complete
        </button>
      )}

      <button
        style={{ marginLeft: "10px" }}
        onClick={() => deleteTask(task.id)}
>
  Delete
</button>
    </li>
  ))}
</ul>
    </div>
  );
}

export default App;
