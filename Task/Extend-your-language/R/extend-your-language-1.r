if2 <- function(condition1, condition2, both_true, first_true, second_true, both_false)
{
  expr <- if(condition1)
  {
    if(condition2) both_true else first_true
  } else if(condition2) second_true else both_false
  eval(expr)
}
