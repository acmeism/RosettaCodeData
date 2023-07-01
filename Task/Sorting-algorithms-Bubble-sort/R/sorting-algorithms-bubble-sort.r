bubbleSort <- function(items)
{
  repeat
  {
    if((itemCount <- length(items)) <= 1) return(items)
    hasChanged <- FALSE
    itemCount <- itemCount - 1
    for(i in seq_len(itemCount))
    {
      if(items[i] > items[i + 1])
      {
        items[c(i, i + 1)] <- items[c(i + 1, i)]#The cool trick mentioned above.
        hasChanged <- TRUE
      }
    }
    if(!hasChanged) break
  }
  items
}
#Examples taken from the Haxe solution.
ints <- c(1, 10, 2, 5, -1, 5, -19, 4, 23, 0)
numerics <- c(1, -3.2, 5.2, 10.8, -5.7, 7.3, 3.5, 0, -4.1, -9.5)
strings <- c("We", "hold", "these", "truths", "to", "be", "self-evident", "that", "all", "men", "are", "created", "equal")
