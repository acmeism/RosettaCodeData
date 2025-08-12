split_by_char <- function(s){
  chars <- strsplit(s,"") |> unlist() |> rle()
  chunks <- strrep(chars$values, chars$lengths)
  cat(chunks, sep=", ")
}

split_by_char("gHHH5YY++///\\ ,,")
