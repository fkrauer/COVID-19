library(dplyr)

# Dynamic input
sitrep <- 51 # This number must be changed every time you add a new sitrep
sitreppath <- "data/COVID/sitreps/" # where you store the .csv that contains the extracted data from tabula
datasetpath <- "data/COVID/" # where you store the dataset you want to append the new data to

# Get file names and date
file1 <- list.files(sitreppath, paste0("sitrep-", sitrep, "-covid-19.csv"))
file2 <- list.files(sitreppath, paste0("sitrep-", sitrep, "-covid-19_adm0.csv"))
date <- as.Date(substr(file1, 8,15), format="%Y%m%d")
lastdate <- date-1

# China Province level data -------------------------------------------------------------------
new <- read.csv(paste0(sitreppath, file1), header=F, stringsAsFactors = F)
head(new)

colnames(new) <- c("adm", "population_E4", "n_inc_conf", "n_inc_sus", "n_inc_deaths", "n_cum_conf", "n_cum_deaths")
new$date <- date
new$adm <- ifelse(new$adm=="Taipei and environs", "Taiwan", new$adm)
new$country <- "China"
new$adm <- ifelse(new$adm=="Total", "all", new$adm)
sort(unique(new$adm))

data <- read.csv(paste0(datasetpath, "WHO_COVID19_CHN_provinces_", lastdate ,".csv"), header = T, stringsAsFactors = F)
data$date <- as.Date(data$date, format="%Y-%m-%d")
data <- merge(data, new, by=intersect(names(data), names(new)), all=T)

# check if cumulative cases are strictly increasing
moo <- data %>% dplyr::group_by(adm) %>% dplyr::arrange(date) %>% 
  dplyr::mutate(cum_conf_diff=c(n_cum_conf[1], diff(n_cum_conf)))

min(moo$cum_conf_diff) # Must not be smaller than 0
max(moo$cum_conf_diff)

# check if cumulative deaths are strictly increasing
moo <- data %>% dplyr::group_by(adm) %>% dplyr::arrange(date) %>% dplyr::filter(date>=as.Date("2020-02-14")) %>% 
  dplyr::mutate(cum_deaths_diff=c(n_cum_deaths[1], diff(n_cum_deaths)))

min(moo$cum_deaths_diff) # Must not be smaller than 0
max(moo$cum_deaths_diff)

sort(unique(data$adm))
length(unique(data$adm)) # must be 35

# check if there is no duplication of province data for a given date
moo <- data %>% dplyr::group_by(adm, date) %>% dplyr::summarise(n=n())
max(moo$n)# must be 1

max(data$date)==date # must be true
all(table(!is.na(data$date))) # must be true

write.csv(data, paste0(datasetpath, "WHO_COVID19_CHN_provinces_", date, ".csv"), row.names = F, quote=F, na="")

rm(moo)
rm(new)
rm(data)

# Country level data -------------------------------------------------------------------
new <- read.csv(paste0(sitreppath, file2), header=F, stringsAsFactors = F)
head(new)
colnames(new)[1:6] <- c("country", "n_cum_conf", "n_inc_conf", "n_cum_deaths", "n_inc_deaths", "class")
new <- new[new$n_cum_conf!="" & !is.na(new$n_cum_conf) & !is.na(new$country) & new$country!="",c(1:6)]
new[] <- lapply(new, function(x) if(is.factor(x)) as.character(x) else x)
new$date <- date
new$country <- gsub("\n", " ", new$country) # correct white space string errors

sort(unique(new$country))

# adjust country names. This is a bit of a hack
new$country <- sub("\\s\\(.*\\)", "", new$country, perl=T) # remove the stuff in the brackets
new$country <- ifelse(new$country=="Republic of Korea", "South Korea", new$country)
new$country <- ifelse(new$country=="Russian Federation", "Russia", new$country)
new$country <- ifelse(new$country=="The United Kingdom" | new$country=="the United Kingdom", "UK", new$country)
new$country <- ifelse(new$country=="United States of America" | new$country=="the United States", "USA", new$country)
new$country <- ifelse(new$country=="Viet Nam", "Vietnam", new$country)
new$country <- ifelse(new$country=="occupied Palestinian territory", "Palestine", new$country)
new$country <- ifelse(new$country=="United Arab Emirates", "United Arab Emirates", new$country)
new$country <- ifelse(new$country=="Saint Barthelemy", "Saint Barthélemy", new$country)

sort(unique(new$country))

new$adm <- "all"

data <- read.csv(paste0(datasetpath, "WHO_COVID19_ALL_ADM0_", lastdate ,".csv"), header = T, stringsAsFactors = F)
data$date <- as.Date(data$date, format="%Y-%m-%d")
data <- merge(data, new, by=intersect(names(data), names(new)), all=T)
data <- unique(data)

# check if cumulative cases are strictly increasing
moo <- data %>% dplyr::group_by(country) %>% dplyr::arrange(date) %>% dplyr::filter(n()>1) %>%  dplyr::mutate(cum_conf_diff=c(n_cum_conf[1], diff(n_cum_conf)))
min(moo$cum_conf_diff) # must not be smaller than 0
max(moo$cum_conf_diff)

# check if cumulative deaths are strictly increasing
moo <- data %>% dplyr::group_by(country) %>% dplyr::arrange(date) %>% dplyr::filter(date>=as.Date("2020-03-01")) %>% 
  dplyr::mutate(cum_deaths_diff=c(n_cum_deaths[1], diff(n_cum_deaths)))
min(moo$cum_deaths_diff)  # must not be smaller than 0
max(moo$cum_deaths_diff)

sort(unique(data$country))


# check if there is no duplication of province data for a given date
moo <- data %>% dplyr::group_by(country, date) %>% dplyr::summarise(n=n())
max(moo$n)# must be 1

max(data$date)==date # must be true
all(table(!is.na(data$date))) # must be true

data <- data[order(data$date, data$country),]
write.csv(data, paste0(datasetpath, "WHO_COVID19_ALL_ADM0_", date, ".csv"), row.names = F, quote=F, na="")


rm(moo)
rm(new)
rm(data)











