#Find the first 8 happy numbers
happies <- c()
i <- 1L
while(length(happies) < 8L)
{
   if(is.happy(i)) happies <- c(happies, i)
   i <- i + 1L
}
happies
