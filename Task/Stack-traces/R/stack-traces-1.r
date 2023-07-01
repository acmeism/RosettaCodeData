foo <- function()
{
   bar <- function()
   {
     sys.calls()
   }
   bar()
}

foo()
