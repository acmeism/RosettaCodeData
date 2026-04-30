metros <- list(list("name" = "Lagos", "population" = 21.0),
               list("name" = "Cairo", "population" = 15.2),
               list("name" = "Kinshasa-Brazzaville", "population" = 11.3),
               list("name" = "Greater Johannesburg", "population" = 7.55),
               list("name" = "Mogadishu", "population" = 5.85),
               list("name" = "Khartoum-Omdurman", "population" = 4.98),
               list("name" = "Dar Es Salaam", "population" = 4.7),
               list("name" = "Alexandria", "population" = 4.58),
               list("name" = "Abidjan", "population" = 4.4),
               list("name" = "Casablanca", "population" = 3.98))

find_index <- function(list, pred) {
  bools <- sapply(list, pred)
  which(bools)[1]-1
}

pred_generic <- function(key, val, f) function(list) f(val, list[[key]])

get_key <- function(list, key, pred) {
  index <- find_index(list, pred)+1
  list[[index]][[key]]
}

find_index(metros, pred_generic("name", "Dar Es Salaam", `==`))
get_key(metros, "name", pred_generic("population", 5, `>`))
get_key(metros, "population", pred_generic("name", "^A", grepl))
