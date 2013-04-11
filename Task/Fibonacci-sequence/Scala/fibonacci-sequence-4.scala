def fib(i:Int):Int = {
    def fib2(i:Int, a:Int, b:Int):Int = i match{
        case 1 => b
        case _ => fib2(i-1, b, a+b)
    }
    fib2(i,1,0)
}
