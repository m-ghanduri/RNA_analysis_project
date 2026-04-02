#!/bin/bash

#this script is supposed to take an input to look for specific compressed fasta or fastq files by matching or using regex and then cleaning
#the files using fastp.
#the cleaned data will be in a subdirectory of the main directory that is at the same level of the directory the file is in
#after the data is cleaned, fastq files will be made for data before and after and placed in folders that categorize them as new or old
#all of the files will be named after the inputs with words added to show if the data is cleaned or raw

#THE SCRIPT IS DESIGNED TO BE RUN WITHIN THE SAME DIRECTORY AS THE RAW DATA

#the first function will be the input function
#the input function takes a string as an input, create an array for the files based on that input, and then store the array
#the script assumes that all pairs are named the same except for the last digit being 1 or 2
#if needed, a pair check can be added later as its own function and then used in fastq_input to clean up the arrays

fastq_input () {
	read -p 'give me a description of your file or files. (Regular expression works as well): ' filenames
	mapfile -t fastq_files < <(ls $filenames) #here because there is an issue with bash not being able to pipe ls into mapfile
							#we instead, use process substitution where we backpipe ls into an empty
							#backpipe to act as a filename or file
}

#this function will take the array from the first function and then clean those files with the same names then output them into
#a 'sister' directory
#it is important to note that unless explicitely mentioned, all variables are global rather than local
fastp_cleaning () {
	#since ls sorts alphabetically, all of our files are going to be grouped properly with odds being forward run, and evens being reverse run
	mkdir ../cleaned_up_fastp_files
	let final_array_element=${#fastq_files[@]}-1
	for (( i = 0; i <= $final_array_element; i+=2 ))
	do
		echo $i
		j=$((i+1))
		fastp -i ${fastq_files[i]} -I ${fastq_files[j]} -o "../cleaned_up_fastp_files/cleaned_${fastq_files[i]}" \
		-O "../cleaned_up_fastp_files/cleaned_${fastq_files[j]}" -V
	done
}

#this function will do a fastq analysis on all of the cleaned and raw files
#the approach here is to concatenate one big string made up of all the file names and then pass it on to fastqc
fastqc_reporting () {
        big_string=''
        for f in "${fastq_files[@]}"; do big_string+="../cleaned_up_fastp_files/cleaned_$f $f " ; done
        mkdir ../fastqc_files_all
        fastqc $big_string -o ../fastqc_files_all
}

fastq_input
#echo "cleaned_${fastq_files[0]}"
fastp_cleaning
fastqc_reporting
