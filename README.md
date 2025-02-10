# Minecraft PaperMC Server with Docker

This repository provides a Docker-based setup for running a **Minecraft PaperMC server**. The setup includes a `Dockerfile`, `compose.yaml`, and scripts to automate downloading and running the server.

## Features

- Uses **Docker Compose** for easy deployment.
- Automatically downloads the latest **PaperMC** JAR file.
- Exposes Minecraft server port **25565**.
- Includes a customizable `entrypoint.sh` script.

## Getting Started

### Prerequisites

Ensure you have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Setup & Usage

1. Clone this repository:

   ```sh
   git clone https://github.com/yourusername/minecraft-papermc-docker.git
   cd minecraft-papermc-docker
   ```

2. Build and run the container:

   ```sh
   docker compose up -d
   ```

   This will:
   - Build the image using the `Dockerfile`.
   - Download the latest PaperMC server JAR.
   - Start the server in a Docker container.

3. To stop the server:

   ```sh
   docker compose down
   ```

### Configuration

- The server runs under the `minecraft_server` service as defined in `compose.yaml`.
- Ports:
  - **25565** (Minecraft default port)
  - **80:8100** (Additional exposed port)
- Persistent storage is mounted under `./src` to `/opt/server`.

## File Overview

- **`Dockerfile`** – Defines the Docker image and setup process.
- **`compose.yaml`** – Defines the services and networking.
- **`entrypoint.sh`** – Handles server startup logic.
- **`get_papermc_jar.sh`** – Downloads the latest PaperMC JAR file.

## Customization

- Modify `entrypoint.sh` to change how the server starts.
- Update `compose.yaml` to add more services if needed.
- Change `get_papermc_jar.sh` to fetch a specific PaperMC version.

## License

This project is open-source under the MIT License.

---

Enjoy your Minecraft server! 🎮