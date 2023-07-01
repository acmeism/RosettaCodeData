fisheryatesknuthshuffle <- function(n)
{
   a <- seq_len(n)
   while(n >=2)
   {
      k <- sample.int(n, 1)
      if(k != n)
      {
         temp <- a[k]
         a[k] <- a[n]
         a[n] <- temp
      }
      n <- n - 1
   }
   a
}

#Example usage:
fisheryatesshuffle(6)                # e.g. 1 3 6 2 4 5
x <- c("foo", "bar", "baz", "quux")
x[fisheryatesknuthshuffle(4)]        # e.g. "bar"  "baz"  "quux" "foo"
