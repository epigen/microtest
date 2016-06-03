# Microtest test data

Microtest is a repository of small test data from various data types, for testing pipelines.

## Usage

### With looper/pypiper in a virtualev


```
virtualenv microtestenv; cd microtestenv; source bin/activate

# install the stack
pip install https://github.com/epigen/looper/zipball/master
pip install https://github.com/epigen/pypiper/zipball/master
pip install https://github.com/epigen/open_pipelines/zipball/master

# clone microtest
git clone https://github.com/epigen/microtest

# run
looper -c microtest/config/microtest_config.yaml
```


### Single pipeline

How to use it to test:

```
python pipelines/pipelines/atacseq_pipeline.py -i microtest/bams/atac-seq_PE.bam -g hg19 --project-root=projects/microtest
```

You could use the chr22.bed file to restrict your analysis to chr22 if you want, maybe with `samtools view -b -L chr22.bed input.bam > output.bam`

## Test data production

How samples were made:

```
samtools view -s .0001 sample.bam -b > new_sample.bam
```
