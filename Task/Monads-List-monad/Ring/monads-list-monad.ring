# Project : Monads/List monad

 func main()
        str = "["
        for x in [3,4,5]
             y = x+1
             z = y*2
             str = str + z + ", "
        next
        str = left(str, len(str) -2)
        str = str + "]"
        see str + nl
