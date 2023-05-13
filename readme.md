
THis repo is a placeholder to record how I can run nangpt on a HPC using singularity and slurm

# To run image with access to cuda GPUs use --gpus all flag
docker run --gpus all nvidia/cuda:10.2-cudnn7-devel nvidia-smi

# Running pytorch in a container using slurm
 To run PyTorch in a Docker container using SLURM:

1. Set up your Docker environment: Install Docker on your system and ensure it is running properly.

2. Build a Docker image: Create a Dockerfile that describes the necessary environment and dependencies for your PyTorch application. Here's a basic example:

```Dockerfile
# Start from a base PyTorch image
FROM pytorch/pytorch:latest

# Install additional dependencies
RUN pip install numpy pandas matplotlib

# Set the working directory
WORKDIR /app

# Copy your PyTorch code into the container
COPY your_code.py /app

# Set the entry point to your Python script
ENTRYPOINT ["python", "your_code.py"]
```

Save this Dockerfile in a directory alongside your PyTorch code file (`your_code.py`).

3. Build the Docker image: Open a terminal and navigate to the directory where you saved the Dockerfile. Run the following command to build the Docker image:

```bash
docker build -t pytorch-app .
```

This command will build the Docker image using the Dockerfile in the current directory and tag it with the name `pytorch-app`. Make sure to include the dot `.` at the end of the command, indicating the build context is the current directory.

4. Launch a SLURM job: Now that you have the Docker image, you can launch a SLURM job to run your PyTorch code. Create a SLURM batch script (let's call it `run_job.sh`) with the following content:

```bash
#!/bin/bash
#SBATCH --job-name=pytorch-job
#SBATCH --output=output.txt
#SBATCH --nodes=1
#SBATCH --gres=gpu:1

# Load the Docker module
module load singularity

# Run the Docker container
singularity exec docker://pytorch-app
```

In this script, you define the job name, output file, number of nodes, and the desired GPU resource (`--gres=gpu:1`). Adjust these parameters according to your needs. The `module load singularity` command loads the Singularity module, which enables you to run Docker containers within SLURM.

5. Submit the SLURM job: Submit the SLURM job by running the following command:

```bash
sbatch run_job.sh
```

This command submits the SLURM job using the `run_job.sh` script.

SLURM will allocate a node with a GPU, and the Docker container will be launched on that node. The PyTorch code specified in the Dockerfile (`your_code.py`) will run inside the container, utilizing the GPU resource.

Remember to modify the Dockerfile, SLURM batch script, and other commands based on your specific requirements.

# Commands
python3 data/shakespeare_char/prepare.py

python3 train.py config/train_shakespeare_char.py

python3 sample.py --out_dir=out-shakespeare-char
