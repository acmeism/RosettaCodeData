animals <- c("Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
             "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig")
elements <- c("Wood", "Fire", "Earth", "Metal", "Water")

get_element <- function(year) elements[1+((year-4)%%10)%/%2]

get_animal <- function(year) animals[1+(year-4)%%12]

get_yinyang <- function(year) ifelse(year%%2==0, "yang", "yin")

years <- c(1935, 1938, 1968, 1972, 1976, 2017)

writeLines(paste0(years, " is the year of the ",
                  get_element(years), " ",
                  get_animal(years),
                  " (", get_yinyang(years), ")."))
