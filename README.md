# Microtest test data

Microtest is a repository of small test data from various data types, for testing pipelines.

## Data descriptions
(please include here a short description of any data files you add)

* `bs_aln_k1k3.bam`: Bisulfite data aligned to the methylated/unmethylated spike-in control sequences (k1/k3).
* `wgbs1.bam`/`wgbs2.bam`: Random samples of unaligned WGBS data.


## Usage

### With looper/pypiper in a virtualev


```bash
# create and activate a virtual environment
virtualenv microtestenv --no-site-packages; cd microtestenv; . ./bin/activate

# install the stack
pip install https://github.com/epigen/looper/zipball/master
pip install https://github.com/epigen/pypiper/zipball/master

# clone open_pipelines and microtest
git clone https://github.com/epigen/open_pipelines
git clone https://github.com/epigen/microtest

# run
export CODE=`pwd`
# run only tutorial pipeline (no additional dependecies)
looper run --file-checks microtest/config/microtest_config.tutorial.yaml

# or run all (would require additional software dependecies)
looper run --file-checks microtest/config/microtest_config.tutorial.yaml
```


### Single pipeline usage

```bash
AMPLICON=`sed 's/,/\t/g' microtest/config/microtest_annotation.tutorial.csv | tail -n 1 | cut -f 14`
GUIDE=`sed 's/,/\t/g' microtest/config/microtest_annotation.tutorial.csv | tail -n 1 | cut -f 15`

python open_pipelines/pipelines/amplicon_simple.py \
-S microtest_amplicon -i microtest/data/amplicon.fastq.gz -g $GUIDE -a $AMPLICON -O microtes_amplicon
```

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
