# Futhark

## Environment setup

This devcontainer will run on any system that is set up to run other devcontainers with docker (but make sure to start it up once, as creating the image takes some time...).

But using the default setup wont be able to access the GPU and none of futharks performance.

To be able to access your (NVIDIA or AMD) GPU with a Linux host, follow a guide such as [this one](https://linuxhandbook.com/setup-opencl-linux-docker/) and comment out the line `,"runArgs": ["--gpus", "all"]` in the .devcontainer.json and the last `RUN` instruction in the Dockerfile (they are for a standard NVIDIA setup and have to be adapted for AMD GPUs).