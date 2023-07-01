print_is_missing <- function(x)
{
  print(missing(x))
}

print_is_missing()                # TRUE
print_is_missing(123)             # FALSE
