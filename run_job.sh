#!/bin/bash
#SBATCH --job-name=pytorch-test-job
#SBATCH --output=output.txt
#SBATCH --nodes=1
#SBATCH --gres=gpu:1

#Load the Docker module
module load singularity

#run the Docker container
singularity exec docker://centospytorch

# submit using
# sbatch run_job.sh