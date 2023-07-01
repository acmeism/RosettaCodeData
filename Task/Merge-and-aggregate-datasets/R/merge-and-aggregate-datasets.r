# load data from csv files
# setwd("C:\Temp\csv\")
# df_patient <- read.csv(file="patients.csv", header = TRUE, sep = ",")
# df_visits <- read.csv(file="visits.csv", header = TRUE, sep = ",", dec = ".", colClasses=c("character","character","numeric"))

# load data hard coded, create data frames
df_patient <- read.table(text = "
PATIENT_ID,LASTNAME
1001,Hopper
4004,Wirth
3003,Kemeny
2002,Gosling
5005,Kurtz
", header = TRUE, sep = ",") #  character fields so no need for extra parameters colClasses etc.

df_visits <- read.table(text = "
PATIENT_ID,VISIT_DATE,SCORE
2002,2020-09-10,6.8
1001,2020-09-17,5.5
4004,2020-09-24,8.4
2002,2020-10-08,
1001,,6.6
3003,2020-11-12,
4004,2020-11-05,7.0
1001,2020-11-19,5.3
", header = TRUE, dec = ".", sep = ",", colClasses=c("character","character","numeric"))

# aggregate visit date and scores
df_agg <- data.frame(
  cbind(
    PATIENT_ID = names(tapply(df_visits$VISIT_DATE, list(df_visits$PATIENT_ID), max, na.rm=TRUE)),
    last_visit = tapply(df_visits$VISIT_DATE, list(df_visits$PATIENT_ID), max, na.rm=TRUE),
    score_sum = tapply(df_visits$SCORE, list(df_visits$PATIENT_ID), sum, na.rm=TRUE),
    score_avg = tapply(df_visits$SCORE, list(df_visits$PATIENT_ID), mean, na.rm=TRUE)
  )
)

# merge patients and aggregate dataset
# all.x = all the non matching cases of df_patient are appended to the result as well (i.e. 'left join')
df_result <- merge(df_patient, df_agg, by = 'PATIENT_ID', all.x = TRUE)

print(df_result)
