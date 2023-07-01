if2 <- function(condition1, condition2, expr_list = NULL)
{
  cl <- as.call(expr_list)
  cl_name <- if(condition1)
  {
    if(condition2) "" else "else1"
  } else if(condition2) "else2" else "else"
  if(!nzchar(cl_name)) cl_name <- which(!nzchar(names(cl)))
  eval(cl[[cl_name]])
}
