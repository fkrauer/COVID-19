# COVID-19

## What are these data?
These are cumulative and incident cases and deaths of COVID-19 in China (province level and total) and international (country-level)  (excluding China). This dataset does not include the Diamond Princess cases. The data are digitized from WHO sitreps using [tabula](https://tabula.technology/). The data are partially checked, but there may still be errors. The date is the date of the last update. Please alert me if you find inconsistencies or data entry errors. I will update this dataset periodically. 

Please note that WHO changed the table outline on March 2. Deaths or incident cases for the country-level dataset prior to this date are not yet in the dataset, because they had merged multiple numbers in the same column, which cannot be extracted nicely with tabula. I haven't had the time yet to update this. If anyone wants to do this, please contact me. The cumulative confirmed cases are registered completely from the start though. If you want to get the incident numbers for each day, you have to diff the cumulative cases.


## How did I make the dataset?
The WHO sitreps are digitized with tabula. I created two different csv files from each sitrep: one for China provinces and one for the country-level data. These csv files are then merged in R with the pre-existing datasets. The script for the merging and checking is in the repository (sitrep_check.R).

These are the individual steps:
1.	Download sitrep from https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports/. Don’t change the file name.
2.	Upload sitrep to tabula, click extract data
3.	Find the table for the Chinese province data. Mark the table WITHOUT the header (otherwise it will mess up the csv)
4.	Click Preview & Export Data -> click Export (as csv) and save. Don’t change the file name. 
5.	Click Revise selection -> clear all selection and find the table with the country-level data. Make a new selection. Select chunks in the table excluding the grey “region” header and the table header (otherwise it will mess up the csv)
6.	Click Preview & Export Data -> click Export (as csv) and save. CHANGE the file name: add “_adm0” at the end of the file name
7.	Open R, run the script sitrep_check.R. The only thing you have to change actively every time you add a sitrep is the number of the newest sitrep you want to add to the dataset. The rest should work automatically UNLESS WHO changes the reporting style. 


## How to use it
The best way to work with the data is to read it with a stats software such as R:
```
update <- "2020-03-11"

## Country-level data (excluding China)
data_all <- read.csv(paste0("WHO_COVID19_ALL_ADM0_", update ,".csv"), header = T, stringsAsFactors = F)
data_all$date <- as.Date(data_all$date, format="%Y-%m-%d")

## China province level data
data_CHN <- read.csv(paste0("WHO_COVID19_ALL_ADM0_", update ,".csv"), header = T, stringsAsFactors = F)
data_CHN$date <- as.Date(data_CHN$date, format="%Y-%m-%d")
```

Andree Valle Campos has written a nice R package [covid19viz](https://github.com/avallecam/covid19viz) to visualize the data.


## Varia
Please cite this github repository and the WHO sitreps when using the data, thank you.  
