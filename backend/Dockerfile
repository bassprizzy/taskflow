## Dockerfile for the backend service
FROM node:20-alpine 
# Set the working directory inside the container
WORKDIR /app
# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./
# Install dependencies without dev dependencies
RUN npm ci --omit=dev
# Copy the rest of the application code to the working directory
COPY server.js ./
# Expose the port that the backend service will run on
EXPOSE 5000
# Start the backend service using the specified command
CMD [ "node", "server.js" ]
## Note: The backend service is configured to run on port 5000.
