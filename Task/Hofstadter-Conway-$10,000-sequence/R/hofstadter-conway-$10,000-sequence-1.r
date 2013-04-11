f = local(
   {a = c(1, 1)
    function(n)
       {if (is.na(a[n]))
            a[n] <<- f(f(n - 1)) + f(n - f(n - 1))
        a[n]}})
