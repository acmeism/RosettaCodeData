leave_last <- function(n) function(v) c(paste0(head(v, -n), collapse = " "), tail(v, n))

chronological_sort <- function(filepath) {
  no_ws <- readLines(filepath) |> strsplit("\\s+")
  df <- sapply(no_ws, leave_last(2)) |> t() |> as.data.frame()
  names(df) <- c("event", "year", "era")
  df$year <- as.numeric(df$year)
  bce <- subset(df, toupper(era) %in% c("BCE", "BC"))
  ce <- subset(df, toupper(era) %in% c("CE", "AD"))
  rbind(sort_by(bce, ~ I(-year)), sort_by(ce, ~ year)) |>
    setNames(NULL) |>
    print(row.names = FALSE, right = FALSE)
}

sapply(paste0("table", 1:3, ".txt"), chronological_sort) |> invisible()
