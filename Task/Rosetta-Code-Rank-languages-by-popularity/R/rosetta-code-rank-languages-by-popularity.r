library(rvest)
library(dplyr)
options(stringsAsFactors=FALSE)

# getting the required table from the rosetta website
langUrl <- "https://rosettacode.org/wiki/Rosetta_Code/Rank_languages_by_popularity/Full_list"
langs <- read_html(langUrl) %>%
  html_nodes(xpath='/html/body/div/div/div[1]/div[3]/main/div[2]/div[3]/div[1]/table') %>%
  html_table() %>%
  data.frame() %>%
  select(c("Rank","TaskEntries","Language"))


 # changing the columns to required format
langs$Rank = paste("Rank: ",langs$Rank)
langs$TaskEntries = paste0("(", format(langs$TaskEntries, big.mark = ",")
                           ," entries", ")")

names(langs) <- NULL

langs[1:10,]
