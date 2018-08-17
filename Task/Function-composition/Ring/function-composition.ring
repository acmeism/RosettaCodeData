# Project : Function composition

sumprod = func1(:func2,2,3)
see sumprod + nl

func func1(func2,x,y)
        temp = call func2(x,y)
        res = temp + x + y
        return res

func func2(x,y)
        res = x * y
        return res
