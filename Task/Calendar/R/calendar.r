library(lubridate)
library(stringi)

# Helper function padding
pad_d  <- function(gr) gr %>% stri_pad_left(2) %>% stri_c(collapse = " ")
pad_l  <- function(gr) gr %>% pad_d() %>% stri_pad_left(20)
pad_r  <- function(gr) gr %>% pad_d() %>% stri_pad_right(20)
pad_20 <- " " %s*% 20

# 1st week mapping
idx_week <- list("1"=1,"7"=2,"6"=3,"5"=4,"4"=5,"3"=6,"2"=7)

# Generate a single month
gen_cal <- function(date_str) {
  str_l <- list()

  # Pick up month name
  month_name <-  month(ymd(date_str),label = T,abbr = F) %>%
      as.character() %>%
      stri_pad_both(20)

  # Add to list with day header
  str_l[length(str_l)+1] <- month_name
  str_l[length(str_l)+1] <- "Mo Tu We Th Fr Sa Su"

  # Day list for the month
  cc <- 1:days_in_month(as.Date(date_str))

  # Staring week
  wd <- wday(ymd(date_str))
  st <- idx_week[as.character(wd)][[1]]

  # Add 1st week
  str_l[length(str_l)+1] <- pad_l(head(cc,st))

  # Middle weeks
  cc <- tail(cc,-st)
  while (length(cc) > 7) {
    str_l[length(str_l)+1] <- pad_l(head(cc,7))
    cc <- tail(cc,-7)
  }

  # Last week
  str_l[length(str_l)+1] <- pad_r(cc)

  # Pad for empty week
  if (length(str_l)==7)
    str_l[length(str_l)+1] <- pad_20

  str_l
}

# Print calendar
print_calendar <- function(target_year) {
  cat("\n",stri_pad_both(target_year,64),"\n\n")
  for (j in seq.int(1,12,3)) {
    cal <- sapply(j:(j+2),\(x) gen_cal(paste0(target_year,"/",x,"/1")))
    xres <- paste(cal[,1],cal[,2],cal[,3],sep = "  ")
    for (i in xres) cat(i,"\n")
  }
}

#
# Main
#

print_calendar("1969")
