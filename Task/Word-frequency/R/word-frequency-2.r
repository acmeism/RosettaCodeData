word_frequency_pipeline <- function(file=NULL, n=10) {
	
  file |>
    vroom::vroom_lines() |>
    stringi::stri_split_boundaries(type="word", skip_word_none=T, skip_word_number=T) |>
    unlist() |>
    tolower() |>
    table() |>
    sort(decreasing = T) |>
    (\(.) .[1:n])() |>
    data.frame()
	
}
