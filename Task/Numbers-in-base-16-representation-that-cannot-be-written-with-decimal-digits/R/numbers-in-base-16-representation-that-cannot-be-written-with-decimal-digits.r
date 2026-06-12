hexnums <- as.character.hexmode(1:500)
has_dec <- function(s) grepl("[0-9]", s)
Filter(Negate(has_dec), hexnums) |> strtoi(base=16)
