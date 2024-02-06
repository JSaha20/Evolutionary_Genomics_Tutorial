# Shell scripting Pipelines
Here we see how to write our commands into a shell script and run.
(Continued from Unix Intermediate. Try exercises there first before doing this)

# Putting commands into a script file
 Use nano or echo.
  - type `nano` into the terminal. Type command and save file as `script.sh`
  - `echo "<command>" > script.sh`. Use any command from the past days of tutorial.
 
# Download data using a script
 - Copy the following into a script.sh file. Note: You can name your file anything. Eg.`get_data.sh`, `download.sh`, etc
	```
		for i in {1..4};
		do
		wget --no-check-certificate https://raw.github.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Telmatherina38.pass.snps.biallelic.Chr$i.1M.vcf.gz;
		done
	```
 - Run this using the command
  `bash script.sh`
# Run commands on all the chromosome files simultaneously
 - Follow a similar syntax like above and get results for all chromosomes:
 Choose any command from the past days. Example commands:
 `plink --double-id --vcf Telmatherina38.pass.snps.biallelic.<chrom>.1M.vcf.gz --out <output_base_name> --pca`
 
# Pipelines
  When we need to run commands in a sequence and the output of the last command is an input for the next we call it a pipeline.
  Example, if we want to download data and run commands on the downloaded data, we might want to put them in a script together one after other.
  Add the commands from the previous steps one after other and save in a script file and run it. Use # to comment so that you know what the command does.
  ```
  #Download data
  
  for i in {1..4};
  do
  wget --no-check-certificate https://raw.github.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Telmatherina38.pass.snps.biallelic.Chr$i.1M.vcf.gz;
  done
  
  #Run plink to generate pca`
  
  for i in {1..4};
  do 
  plink --double-id --vcf Telmatherina38.pass.snps.biallelic.Chr$i.1M.vcf.gz --out <output_base_name> --pca;
  done
  ```
 But you see that you are running this for the same 4 chromosomes. Hence it is okay to run it entirely in the for loop. Like as follows:
  ```
  
  for i in {1..4};
  do
  wget --no-check-certificate https://raw.github.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Telmatherina38.pass.snps.biallelic.Chr$i.1M.vcf.gz;
   
  for i in {1..4};
  do 
  plink --double-id --vcf Telmatherina38.pass.snps.biallelic.Chr$i.1M.vcf.gz --out <output_base_name> --pca;
  done
  ```
 # Good practices:
 # Using # to comment about each step that you are doing using the script.
 These lines are not run by the computer. It is only for you to track which commands are being used for what purpose in your pipeline.
 ```
  #Download data
  
  for i in {1..4};
  do
  wget --no-check-certificate https://raw.github.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Telmatherina38.pass.snps.biallelic.Chr$i.1M.vcf.gz;
  done
  
  #Run plink to generate pca`
  
  for i in {1..4};
  do 
  plink --double-id --vcf Telmatherina38.pass.snps.biallelic.Chr$i.1M.vcf.gz --out <output_base_name> --pca;
  done
  ```
 But you see that you are running this for the same 4 chromosomes. Hence it is okay to run it entirely in the for loop. Like as follows:
  ```
  #Download data
  
  for i in {1..4};
  do
  wget --no-check-certificate https://raw.github.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Telmatherina38.pass.snps.biallelic.Chr$i.1M.vcf.gz;
 
 #Run plink to generate pca`
  
  for i in {1..4};
  do 
  plink --double-id --vcf Telmatherina38.pass.snps.biallelic.Chr$i.1M.vcf.gz --out <output_base_name> --pca;
  done
 ```
 
 # Getting a log file for the commands we run in our pipeline
 Sometimes there might be programs/ tools which do not print a message on the terminal. Or may be they do print some message. When you run the pipeline for a lot of input files may be you would not be able to see what each message is from each file run. In such cases we would want to output the message in to a log file.
 To do so you need to redirect the stdout (which was denoted by the numerical 1 and numerical 2 for std err) into a log file (Mentioned in Unix Basics).
 Here we can do the following:
 
  ```
  #Download data
  
  for i in {1..4};
  do
  wget --no-check-certificate https://raw.github.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Telmatherina38.pass.snps.biallelic.$i.1M.vcf.gz 2>&1 log_chr$i.txt;
 
 #Run plink to generate pca`
  
  for i in {1..4};
  do 
  plink --double-id --vcf Telmatherina38.pass.snps.biallelic.$i.1M.vcf.gz --out <output_base_name> --pca 2&1> log_chr$i_pca.txt;
  done
  ```
  - Note how the log from download step has no name to say download, but from pca has. To avoid confusions it is also better to just put it in the same log file with some modifictions to our code.
  ```
  #Download data
  
  for i in {1..4};  
  do
  #add name of step
  echo download of telmatherina chr$i > log.txt;
  
  #command
  wget --no-check-certificate https://raw.github.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Telmatherina38.pass.snps.biallelic.$i.1M.vcf.gz 2>>&1 log.txt;
 
 #Run plink to generate pca`
  
  for i in {1..4};
  do 
  #add name of step
  echo plink run for pca of telmatherina chr$i >> log.txt;
  
  #command
  plink --double-id --vcf Telmatherina38.pass.snps.biallelic.$i.1M.vcf.gz --out <output_base_name> --pca 2>>&1 log.txt;
  done
  ```
 - Note the usage of `>>` for redirection into a file. Make sure to add those after creation of first file as otherwise the information from each step won't be appended.
 
 # Adding more information to the pipeline script:
 Adding information such as Date of creation, Name of the owner of the script and using a shebang (a Unix syntax to specify that it is indeed a shell script. It is the first line that looks like #!/bin/bash. Program tries after this)
 
  ```
  06/02/2024
  Owner: Jaysmita Saha
  
  #Print date automatically into the script
  echo `date` > log.txt;
  
  #Download data
  
  for i in {1..4};  
  do
  #add name of step
  echo download of telmatherina chr$i >> log.txt;
  
  #command
  wget --no-check-certificate https://raw.github.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Telmatherina38.pass.snps.biallelic.$i.1M.vcf.gz 2>>&1 log.txt;
 
 #Run plink to generate pca`
  
  for i in {1..4};
  do 
  #add name of step
  echo plink run for pca of telmatherina chr$i >> log.txt;
  
  #command
  plink --double-id --vcf Telmatherina38.pass.snps.biallelic.$i.1M.vcf.gz --out <output_base_name> --pca 2>>log.txt;
  done
  ```
# Excercise
- Add more steps from last days commands on to this and run this script to get all results for 3 chromosomes.
