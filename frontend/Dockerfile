FROM node:20-alpine
# Set the working directory inside the container
WORKDIR /app
# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./
# Install dependencies without dev dependencies
RUN npm ci 
# Copy the react of the application code to the working directory
COPY . .
RUN npm run build
# Expose the port that the frontend service will run on
FROM nginx:alpine
COPY --from=0 /app/dist /usr/share/nginx/html
EXPOSE 80

