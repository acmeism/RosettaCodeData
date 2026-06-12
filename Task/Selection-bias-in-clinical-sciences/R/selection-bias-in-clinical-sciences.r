#Helper function that returns TRUE with probability p and FALSE otherwise
randp <- function(p) runif(1) < p

#Create a data frame to store everything
covid_study <- data.frame("patid" = 1:10000,
                          "meds_started" = FALSE,
                          "total_dose" = 0,
                          "has_covid" = FALSE,
                          "group" = "untreated")

#Function that simulates a single day of the study
update_study <- function(df, pcovid = 0.001, pmedstart = 0.005, pmedcont = 0.25, doses = c(3, 6, 9)) {
  for (i in df$patid) {
    #If a patient has COVID, we censor their observations
    if (df$has_covid[i]) next
    if (!df$meds_started[i]) {
      df$meds_started[i] <- randp(pmedstart)
    } else {
      dose <- ifelse(randp(pmedcont), sample(doses, 1), 0)
      df$total_dose[i] <- df$total_dose[i] + dose
    }
    df$has_covid[i] <- randp(pcovid)
  }
  #Update groups based on observed total doses
  df$group[df$total_dose > 0] <- "irregular"
  df$group[df$total_dose >= 100] <- "regular"
  return(df)
}

#Simulate 180 days and show monthly outcomes
for (day in 1:180) {
  covid_study <- update_study(covid_study)
  if (day %% 30 == 0) {
    cat("\n", "Day", day)
    table(ordered(covid_study$group,
                  levels = c("untreated", "irregular", "regular"),
                  labels = c("Untreated", "Irregular use", "Regular use")),
          ordered(covid_study$has_covid,
                  levels = c(TRUE, FALSE),
                  labels = c("COVID", "No COVID"))) |> print()
  }
}

#Final test
kruskal.test(has_covid ~ group, data = covid_study)
