daynames <- c("Sunday", "Monday", "Tuesday", "Wednesday",
              "Thursday", "Friday", "Saturday")

isleapyear <- function(y) (y%%4==0)&((y%%100!=0)|(y%%400==0))

anchors <- function(y) c(ifelse(isleapyear(y), 4, 3),
                         ifelse(isleapyear(y), 1, 7),
                         7, 4, 2, 6, 4, 1, 5, 3, 7, 5)

doomsday <- function(y) (2+5*(y%%4)+4*(y%%100)+6*(y%%400))%%7
wd <- function(y, m, d) (doomsday(y)+d-anchors(y)[m])%%7

test_dates <- list(c(1800, 1, 6),
                   c(1875, 3, 29),
                   c(1915, 12, 7),
                   c(1970, 12, 23),
                   c(2043, 5, 14),
                   c(2077, 2, 12),
                   c(2101, 4, 2))

raw_wds <- sapply(test_dates, function(v) do.call(wd, as.list(v)))
cat(daynames[raw_wds+1], "\n")
