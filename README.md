# Evolutionary Genomics Tutorial
A tutorial/assignment on how to get from raw sequencing reads to a basic population genetic analysis.

## Introduction

### Background and Aim
This activity will guide you through some of the basic steps for getting from whole-genome sequencing data to filtered variant calls and to do some basic population/evolutionary genetic analyses. Some intermediate steps are simplified but it should give you a good idea.

### Learning goals
After this activity, you should be able to
- understand the structure of .fastq, .fasta, .sam/.bam, .vcf files
- run basic quality control (QC) on sequencing reads
- align reads to a reference genome and get basic alignment stats
- call genetic variants and understand and apply basic hard filters to variants
- run basic QC on a vcf file
- reconstruct a basic phylogeny applying the neighbour-joinint algorithm to pairwise genetic differences

### How to follow this tutorial

#### General user (UAntwerp Omics Techniques course students can skip this section)

You need a computer with a unix command line and the following software installed
- fastQC
- bwa
- samtools
- bcftools
- plink

All these programs can be easily installed with conda or other package managers. You can search the internet on how to install them.

#### University of Antwerp students of Omics Techniques course

To run the analyses, you first need to connect to the CalcUA login node the way that you had learned it. From there you will connect to a different server/computer where you can run compuations.

Connect to leibniz the way that you have learned it, e.g., 

`ssh -i <path_to_key_file> <username>@login1-leibniz.hpc.uantwerpen.be`

Note that things in <> should be replaced by the value approapriate for your case, e.g., <username> could be replaced by your vscXXXX username. On windows, use MobaXterm to establish connection. Hint: your key file is likely located in a hidden subfolder of your home folder: `~/.ssh/`
  
Once on the leibniz login node, connect to our private node (*r0c03cn1*)

`ssh r0c03cn1`
  
On the privade node, activate a compute environment that has all software installed that we will need.
  
`/data/antwerpen/grp/asvardal/miniconda3/bin/conda activate`
  
Start a byobu session
  
`byobu`

  

  
  
## The study system
 
See presentation slides by Henrique Leitao
  
## Read aligment 
  
  ### Preparation
  
[If not already done] Create a folder `<firstname_lastname>` in `/scratch/antwerpen/grp/aomicscourse`
 
  <details>
    <summary>Show me how to do this.</summary>
    
    
    cd /scratch/antwerpen/grp/aomicscourse
    mkdir max_mustermann
    
    
  </details>
  
  
  You will receive reads of the follwing 20 samples
  
  ```
  HC_21_002
  HC_21_007
  HC_21_010
  HC_21_019
  HC_21_024
  HC_21_032
  HC_21_088
  HC_21_093
  HC_21_095
  HC_21_103
  HC_22_025
  HC_22_040
  HC_22_049
  HC_22_054
  HC_22_126
  HC_22_130
  HC_22_132
  HC_22_134
  HC_22_141
  HC_22_225
  ```
  
  The sequencing reads for these samples are in the folder
  
  `/scratch/antwerpen/grp/aomicscourse/genomics_activity/alignment_variant_calling/reads`
  
  Assign the samples to different group members, so that each of you gets a fair share. For example, if there are 4 students, each should run the alignments for five (different) samples.
  
  Create symbolic links to the read files of your samples in your own folder.
  
   <details>
    <summary>1. Show me how to do this.</summary>
    
    
    cd /scratch/antwerpen/grp/aomicscourse/<firstname_lastname>
    #do this for each of your samples
    ln -s ../genomics_activity/alignment_variant_calling/reads/<my_sample.1.fq> <my_sample.1.fq>
    ln -s ../genomics_activity/alignment_variant_calling/reads/<my_sample.2.fq> <my_sample.2.fq>
    
  </details>
  
  Create symbolic links to the reference genome folder `/scratch/antwerpen/grp/aomicscourse/genomics_activity/alignment_variant_calling/reference` in your own folder.
  
 <details>
  <summary>2. Show me how to do this.</summary>


    cd /scratch/antwerpen/grp/aomicscourse/<firstname_lastname>
    ln -s ../genomics_activity/alignment_variant_calling/reference reference

 </details>
     
 ### Inspecting the input data

 #### Inspect the read files. 

 How many reads are there per sample?

 <details>
  <summary>3. Show me how to do this.</summary>

    #Count number of lines
    wc -l *.fq
         1007884 HC_21_002.1.fq
         1009552 HC_21_002.2.fq
          238448 HC_21_007.1.fq
          239436 HC_21_007.2.fq
          286836 HC_21_010.1.fq
          286660 HC_21_010.2.fq
          241872 HC_21_019.1.fq
          242180 HC_21_019.2.fq
          100992 HC_21_024.1.fq
          101656 HC_21_024.2.fq
          412384 HC_21_032.1.fq
          415936 HC_21_032.2.fq
          660088 HC_21_088.1.fq
          663200 HC_21_088.2.fq
          881092 HC_21_093.1.fq
          882908 HC_21_093.2.fq
          858476 HC_21_095.1.fq
          861504 HC_21_095.2.fq
          712864 HC_21_103.1.fq
          714756 HC_21_103.2.fq
          624988 HC_22_025.1.fq
          624972 HC_22_025.2.fq
          590432 HC_22_040.1.fq
          591336 HC_22_040.2.fq
          680228 HC_22_049.1.fq
          679940 HC_22_049.2.fq
          673452 HC_22_054.1.fq
          674240 HC_22_054.2.fq
          699404 HC_22_126.1.fq
          700336 HC_22_126.2.fq
          605916 HC_22_130.1.fq
          606204 HC_22_130.2.fq
          661068 HC_22_132.1.fq
          662304 HC_22_132.2.fq
          644288 HC_22_134.1.fq
          644504 HC_22_134.2.fq
          563280 HC_22_141.1.fq
          563164 HC_22_141.2.fq
          684992 HC_22_225.1.fq
          684816 HC_22_225.2.fq
        23678588 total
   
    #To get the read numbers, you need to divide the line numbers by 4!
 </details> 
    
What is the read length? Do all reads have the same length?
   
#### Inspect the reference genome.
   
How many chromosomes does the reference genome have, what are their names?
   
Hint: Use the command `grep` to search for header lines. See `grep --help`

<details>
  <summary>4. Show me how to do this.</summary>

    grep '>' reference/HC_reference.fa
 
  Note: The '' around the greater than is really important, because we search for a litteral greater than symbol in the file. We do not want bash to interpret this as a file redirection symbol.
    
  

</details>
  
What is the size of each chromosome?
   
Hint: Inspect the text file `reference/HC_reference.fa.dict`
   
Try to blast a bit of the reference genome against the NCBI database. Can you confirm which organism it is from?

   https://blast.ncbi.nlm.nih.gov/   

### Running QC on the read files
To check the quality of the reads, we will use a program called [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) 

Run `fastqc --help`

To run QC, create a folder for the output inside your folder
  mkdir read_QC

Then run
   fastqc -o read_QC *.fq

Once this is finished, copy the resulting read_QC/*.html files to your local computer and inspect them in a web browser.
   

<details>
  <summary>5. Show me how to do this.</summary>

  - On Windows:
    Drag and drop files using MobaXterm
  - On Mac/Linux:
    Copy files with
      ```
      scp -i ~/.ssh/<private_key_file> <vsc_username>@login1-leibniz.hpc.uantwerpen.be:/scratch/antwerpen/grp/aomicscourse/<firstname_lastname>/read_QC/*.html .
      ```
  

</details>
   
Try to interpret the resulting .html files. The base qualty and read length plots are the most important. Don't spend too much time on the others.

## Aligning the reads
For read alignment we will use the `mem` algorithm of the program [`bwa`](https://bio-bwa.sourceforge.net/).   

Check to options of `bwa mem` by typing `bwa mem` into the shell.
  
Use bwa to align each of your samples against the reference genome. You can use 4 threads per sample to speed up the alignment.
   
<details>
  <summary>6. Show me how to do this.</summary>

    bwa mem -t 4 reference/HC_reference.fa <sample_id>.1.fq <sample_id>.2.fq > <sample_id>.sam
    
  
</details>

Inspect the resulting samfiles using `less` or `head`. Are the reads sorted?
  
Sort fix mate information and sort reads using samtools and index the sorted alignments.
  ```
  samtools fixmate -m -u <sample_id>.sam - | samtools sort > <sample_id>.sorted.bam
  samtools index <sample_id>.sorted.bam
  ```
Check that the resulting binary alignment (bam) file is sorted. Note: You cannot inspect binary files directly with `less` or `head`. You need to use `samtools view`, e.g.,
  ```
  samtools view -h <sample_id>.sorted.bam | less -S
  ```
### QC on the alignments
Run `samtools flagstat` to get some quick QC on the alignments.
  
<details>
  <summary>7. Show me how to do this.</summary>

    samtools flagstat <sample_id>.sorted.bam
    
  
</details>
  
What percentage of reads mapped for each sample? What percentage is properly paired?
  
## Variant calling

We will use `bcftools` to call variants. Each of you should now call variants for all samples jointly, including the ones aligned by your colleagues. However, each of you should call variants for a different chromosome!
  
So first, coordinate with your colleagues who has which read files, and either create symlinks to them or reference them directly in the calling command.
  
The calling command is a two step command. `bcftools mpileup` creates information about all reads at each position. `bcftools call` then determines variants. The overall structure of the command is as follows:
  ```
  bcftools mpileup --regions {chromosome} -f {reference.fa} {sample1.bam} .. {sampleN.bam} | bcftools call -mv - > {output.vcf}
  ```
  
 Make sure to use all 20 samples in the calling! Can you adapt this for your case?
  
 <details>
  <summary>8. Show me how to do this.</summary>
    #Say I wanted to run this on chr14
    bcftools mpileup --regions chr14 -f reference/HC_reference.fa *.sorted.bam ../first_colleague/*.sorted.bam ../second_colleague/*.sorted.bam ../third_colleague/*.sorted.bam | bcftools call -mv - > variants.raw.vcf
  
  Note: This relies on all colleagues having all the right files present. This might be a dangerous assumtions. It would be safer to reference the path to the .sorted.bam files for each sample explictly. 
    
  
</details>

  Inspect the resulting vcf file. Which type of variants does it contain? How many SNPs does it contain? 
  
  Which INFO annotations does the VCF file contain? What is the meaning of MQ and MQ0F
  
  ### Variant filtering
  
  Lets mark some snps as 'bad' based on information in the vcf file. Specifically, we want to flag SNPs with a phred quality score of less than 20, and SNPs with an average mapping quality of <50. We want to mark these potential problems in the FILTER column of the vcf, but we do not yet want to exclude these SNPs from the file. This is called soft filtering.
  
  The commands for this are as follows
  
    
    bcftools filter --exclude 'QUAL<20' --soft-filter LowQual  variants.raw.vcf > variants.filter1.vcf
    bcftools filter --exclude 'MQ<50' --soft-filter BadMapping  variants.filter1.vcf > variants.filter.vcf
    
      
    
  Can you run this more efficiently by using a pipe `|`?
  
  <details>
    <summary>9. Show me how to do this.</summary>
    
    
    bcftools filter --exclude 'QUAL<20' --soft-filter LowQual  variants.raw.vcf | bcftools filter --exclude 'MQ<50' --soft-filter BadMapping > variants.filter.vcf
    
    
  
 </details>
      
  ### VCF file subsetting
  
  bcftools is an extremely powerful tool. Try to use `bcftools view` to create a vcf of biallelic snps that passed all filters.

  Check the options and examples here: https://samtools.github.io/bcftools/bcftools.html#view
  Or type `bcftools view` to see concise explanations.
      
  <details>
   <summary>10. Show me how to do this.</summary>
    
    
      bcftools view --max-alleles 2 --types snps  --apply-filters PASS variants.filter.vcf > snps.pass.biallelic.vcf
  
  </details>
    
      
      
 
