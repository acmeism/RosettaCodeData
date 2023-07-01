fac x = case x of 0 -> 1
                  _ -> x * fac (x-1)
