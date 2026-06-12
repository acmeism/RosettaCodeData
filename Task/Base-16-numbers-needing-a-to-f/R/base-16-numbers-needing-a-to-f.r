hexnums <- as.character.hexmode(1:500)
has_nondec <- function(s) grepl("[a-f]", s)
Filter(has_nondec, hexnums) |> strtoi(base=16)
