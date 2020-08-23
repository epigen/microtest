#!/bin/bash
#SBATCH --job-name='{JOBNAME}'
#SBATCH --output='{LOGFILE}'
#SBATCH --mem='{MEM}'
#SBATCH --cpus-per-task='{CORES}'
#SBATCH --time='{TIME}'
#SBATCH --partition='{PARTITION}'
#SBATCH -m block
#SBATCH --ntasks=1

echo 'Compute node:' `hostname`
echo 'Start time:' `date +'%Y-%m-%d %T'`

# Create (isolated) virtual environment
virtualenv microtestenv

cd microtestenv

# Make sure there's nothing in your PYTHONPATH
export PYTHONPATH=

# "Source" to activate the environment
# this is equivalent to the "source" command
# but that cannot be executed inside a job/process or
# would spawn another shell
. ./bin/activate

# install the stack
pip install "peppy>=0.30.2,<1.0.0" "looper>=1.2.0,<2.0.0" "piper>=0.12.1,<1.0.0"

# clone pipelines
git clone https://github.com/epigen/open_pipelines

# clone microtest
git clone https://github.com/epigen/microtest

# run
looper run microtest/config/microtest_config.yaml --sel-attr protocol --sel-incl Amplicon
# looper run microtest/config/microtest_config.yaml --sel-attr protocol --sel-incl A{mplicon,TAC-seq}

echo 'End time:' `date +'%Y-%m-%d %T'`
