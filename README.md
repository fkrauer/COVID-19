# COVID-19

## What are these data?
These are cumulative and incident cases and deaths of COVID-19 in China at province-level. Digitized from WHO sitreps with tabula. The data is partially checked, but there may still be errors. The date is the date of the last update (6 pm MEZ/CET). Please alert me if you find inconsistencies or data entry errors. I will update this dataset periodically. 

## How did I make the dataset?
The WHO sitreps are digitized with tabula. I created two different csv files from each sitrep: one for China provinces and one for the country-level data. These csv files are then merged in R with the pre-existing datasets. The script for the merging and checking is in the repository (sitrep_check.R).

These are the individual steps:
1.	Download sitrep from https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports/. Don’t change the file name.
2.	Upload sitrep to tabula, click extract data
3.	Find the table for the Chinese province data. Mark the table WITHOUT the header (otherwise it will fuck up the csv)
4.	Click Preview & Export Data -> click Export (as csv) and save. Don’t change the file name. 
5.	Click Revise selection -> clear all selection and find the table with the country-level data. Make a new selection. Select chunks in the table excluding the grey “region” header and the table header (otherwise it will fuck up the csv)
6.	Click Preview & Export Data -> click Export (as csv) and save. CHANGE the file name: add “_adm0” at the end of the file name
7.	Open R, run the script sitrep_check.R. The only thing you have to change actively every time you add a sitrep is the number of the newest sitrep you want to add to the dataset. The rest should work automatically UNLESS WHO changes the reporting style. 


## How to use it
The best way to work with the data is to read it with a stats software such as R:




## Varia
Please cite this github repository and the WHO sitreps when using the data, thank you.  
