# Use a lightweight Node.js image as base
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to WORKDIR
COPY ./app/package*.json ./

# Install dependencies
RUN npm install --production

# Copy application code to WORKDIR
COPY ./app .

# Expose port 3000
EXPOSE 3000

# Command to run the application
CMD ["node", "app.js"]
