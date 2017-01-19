# Microtest test data

Microtest is a repository of small test data from various data types, for testing pipelines.

## Usage

### With looper/pypiper in a virtualev


```bash
# create and activate a virtual environment
virtualenv microtestenv --no-site-packages; cd microtestenv; . ./bin/activate

# install the stack
pip install https://github.com/epigen/looper/zipball/master
pip install https://github.com/epigen/pypiper/zipball/master
pip install https://github.com/epigen/open_pipelines/zipball/master

# clone microtest
git clone https://github.com/epigen/microtest

# run
looper run --file-checks microtest/config/microtest_config.yaml

# or run only tutorial pipeline (no pipeline requirements)
looper run --file-checks microtest/config/microtest_config.tutorial.yaml
```


### Single pipeline

How to use it to test:

```bash
python pipelines/pipelines/atacseq_pipeline.py \
-i microtest/bams/atac-seq_PE.bam \
-g hg19 \
--project-root=projects/microtest
```

You could use the chr22.bed file to restrict your analysis to chr22 if you want, maybe with `samtools view -b -L chr22.bed input.bam > output.bam`

## Test data production

How samples were made:

```bash
samtools view -s .0001 sample.bam -b > new_sample.bam
```

## Automatic testing with a Github hook

1. Open a listening port for webhooks:
    1. Get ngrok at https://ngrok.com and open a port: `./ngrok 3456`
    2. add that URL + "/payload" to the github webhook with a secret key
2. Create a listening server:
    1. `git clone git@github.com:afrendeiro/github-webhook-handler.git`
    2. modify `github-webhook-handler/repos.json` with your repositories that should trigger the testing and the secret key(s)
    3. start the server and leave it running: `python github-webhook-handler/index.py 4567`

When there is a push to your repositories, `run_microtest.sh` will run.
This creates an isolated virtual environment, installs dependencies (not pipeline-specific ones though!)
and runs the pipelines on the microtest data (similar to the example above).
