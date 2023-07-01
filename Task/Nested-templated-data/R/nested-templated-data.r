fill_template <- function(x, template, prefix = "Payload#") {
  for (i in seq_along(template)) {
    temp_slice <- template[[i]]
    if (is.list(temp_slice)) {
      template[[i]] <- fill_template(x, temp_slice, prefix)
    } else {
      temp_slice <- paste0(prefix, temp_slice)
      template[[i]] <- x[match(temp_slice, x)]
    }
  }
  return(template)
}

library("jsonlite") # for printing the template and result
template <- list(list(c(1, 2), c(3, 4), 5))
payload  <- paste0("Payload#", 0:6)
result   <- fill_template(payload, template)

cat(sprintf(
  "Template\t%s\nPayload\t%s\nResult\t%s",
  toJSON(template, auto_unbox = TRUE),
  toJSON(payload, auto_unbox = TRUE),
  toJSON(result, auto_unbox = TRUE)
))
