# Stage 1: Building the app
FROM node:latest as build-stage

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the project files into the Docker image
COPY . .

# Build the app
RUN npm run build

# Stage 2: Setting up the Bun runtime environment
FROM oven/bun:debian

# Set the working directory
WORKDIR /app

# Copy the build artifacts from the build stage
COPY --from=build-stage /app/dist /app/dist

# Expose the port the app runs on
EXPOSE 3000

# Start the app using Bun
CMD ["bun", "run", "dist/server.js"]
