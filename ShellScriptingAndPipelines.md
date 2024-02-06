# Shell scripting Pipelines
Here we see how to write our commands into a shell script and run.
(Continued from Unix Intermediate. Try exercises there first before doing this)

# Putting commands into a script file
 Use nano or echo.
  Answer
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
  Add the commands from the previous steps one after other and save in a script file and run it.
 
 