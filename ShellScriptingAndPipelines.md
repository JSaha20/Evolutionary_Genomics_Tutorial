# Shell scripting Pipelines
Here we see how to write our commands into a shell script and run.
(Continued from Unix Intermediate. Try exercises there first before doing this)

# Getting out command into a script file
 Use nano or echo.
  Answer
  - type `nano` into the terminal. Type command and save file as `script.sh`
  - `echo "<command>" > script.sh`. Use any command from the past days of tutorial.
 
# Download data using a script
 - Copy the following into a script.sh file. Note: You can name your file anything. Eg.`get_data.sh`, `download.sh`, etc
	```for i in {1..4};
	do
	wget --no-check-certificate https://raw.github.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Telmatherina38.pass.snps.biallelic.Chr$i.1M.vcf.gz;
	done
	```
