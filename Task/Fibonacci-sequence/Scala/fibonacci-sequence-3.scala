def fib(i:Int, a:Int=1, b:Int=0):Int = i match{
    case 1 => b
    case _ => fib(i-1, b, a+b)
}
