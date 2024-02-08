# GRIFO eDNA analysis 
In this tutorial we will analyse eDNA data sequenced on a minION sequencing device.
We start from demultiplexed data and end with a table with species ID’s
Data is in fastq.gz format, sorted into folders per barcode

Make a folder named eDNA and go into that folder

Clone the repository

```
git clone https://github.com/pascalhabluetzel/grifo.git
```

Enter the grifo folder

```
cd grifo 
```

Enter folder `src_0.5`

```
cd src_0.5 
```

Have a look at what files are in the folder

```
ls
```
 
`grifo.py` is the script we will run. It will call the two other scripts.

We start by making a config file
This file contains information which can be used by the program, such as the path to your data, and settings for filtering.

```
nano config.ini
```

Paste this information:
```
[paths]
path_data = ../data # the path to your data
path_to_blastdb = ../reference_databases/SILVA_138/SILVA_138_SSURef_tax_silva.fasta #path to your database

[NanoFilt]
minlength = 600 #minimum length of your sequences
maxlength = 800 #maximum length of your sequences
qscore = 8

[ashure]
niter = 15 #number of iterations for the clustering algorithm

[BLAST]
numthreads = 8
mts = 10
pct_ident = 95 #percentage similarity for blast
db = SILVA_138
```


In the grifo folder, Make a folder ./data with the demultiplexed data

```
mkdir data
```

copy the barcode folders containing the demultiplexed data to this folder

Build conda a environment:

```
conda create -n “eDNA” python=3.8.18
conda activate eDNA
conda install -c bioconda nanofilt
pip install scikit-learn
pip install hdbscan
sudo apt-get -y install spoa       	
pip install parasail
pip install scipy
pip install cutadapt
sudo apt install ncbi-blast+
```

Make a folder in the grifo folder  ./reference_databases/SILVA_138 with reference database

Inside folder ./reference_databases/SILVA_138  download database information

```
wget  https://www.arb-silva.de/fileadmin/silva_databases/release_138_1/Exports/SILVA_138.1_SSURef_NR99_tax_silva.fasta.gz
```
Unzip database 

```
gunzip SILVA_138.1_SSURef_NR99_tax_silva.fasta.gz
```
Build and index the database


```
makeblastdb -in SILVA_138.1_SSURef_NR99_tax_silva.fasta -parse_seqids -blastdb_version 5 -title "Silva_18S" -dbtype nucl 
```      

Inside folder ./grifo/src_0.5 run the grifo python script


```
python grifo.py
```
