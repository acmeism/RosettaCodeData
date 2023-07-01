showmenu <- function(choices = NULL)
{
   if (is.null(choices)) return("")
   ans <- menu(choices)
   if(ans==0) "" else choices[ans]

}
str <- showmenu(c("fee fie", "huff and puff", "mirror mirror", "tick tock"))
str <- showmenu()
