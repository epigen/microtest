> :warning: **The repository is undergoing updating**: Not everything is compatible with the latest PEP stack versions!


# Microtest test data

Microtest is a repository of small test data from various data types, for testing pipelines.

## Data descriptions
(please include here a short description of any data files you add)

* `atac-seq_PE.bam`: Random sample of paired-end ATAC-seq
* `atac-seq_SE.bam`: Random sample of single-end ATAC-seq
* `bs_aln_k1k3.bam`: Bisulfite data aligned to the methylated/unmethylated spike-in control sequences (k1/k3).
* `chip-seq_PE.bam`: Random sample of paired-end ChIP-seq
* `chip-seq_SE.bam`: Random sample of single-end ChIP-seq
* `chipmentation_PE.bam`: Random sample of paired-end ChIPmentation
* `chipmentation_SE.bam`: Random sample of single-end ChIPmentation
* `dropseq_human.bam`: Random sample of Drop-seq from human
* `dropseq_mouse.bam`: Random sample of Drop-seq from mouse
* `hichip_PE.bam`: Random sample of paired-end Hi-ChIP
* `wgbs1.bam`/`wgbs2.bam`: Random samples of unaligned WGBS data.


## Usage

### With looper/pypiper in a virtualev


```bash
# create and activate a virtual environment
virtualenv microtestenv; cd microtestenv; . ./bin/activate

# install the stack
pip install looper==1.2.0
pip install piper==0.12.1

# clone open_pipelines and microtest
git clone https://github.com/epigen/open_pipelines
git clone https://github.com/epigen/microtest

# run
export CODE=`pwd`
# run only tutorial pipeline (no additional dependecies)
looper run microtest/config/microtest_config.yaml --sel-attr protocol --sel-incl Amplicon

# or run all (would require additional software dependecies)
# for now only ATAC-seq has been adapted
looper run microtest/config/microtest_config.yaml --sel-attr protocol --sel-incl ATAC-seq
```


### Single pipeline usage

```bash
AMPLICON=`sed 's/,/\t/g' microtest/config/microtest_annotation.tutorial.csv | tail -n 1 | cut -f 14`
GUIDE=`sed 's/,/\t/g' microtest/config/microtest_annotation.tutorial.csv | tail -n 1 | cut -f 15`

python open_pipelines/pipelines/amplicon_simple.py \
-S microtest_amplicon -i microtest/data/amplicon.fastq.gz -g $GUIDE -a $AMPLICON -O microtest_amplicon
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
