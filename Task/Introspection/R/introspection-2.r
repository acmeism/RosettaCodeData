bloop <- -3.4
if(exists("bloop", envir=globalenv()) && exists("abs") && is.function(abs))
{
   abs(bloop)
}
