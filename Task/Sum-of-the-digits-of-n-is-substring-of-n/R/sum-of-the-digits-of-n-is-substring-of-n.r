#
# One-liner solution: find all n < 1000 where digit sum is substring of n
#
solutions <- Filter(function(n) grepl(
  as.character(sum(as.integer(strsplit(as.character(n), "")[[1]]))),
  as.character(n),
  fixed = TRUE
), 0:999)

# Display the result
solutions

