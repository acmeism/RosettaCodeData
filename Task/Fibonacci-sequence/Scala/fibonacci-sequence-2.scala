//syntactic sugar for Stream.cons, this is unnecessary but makes the definition prettier
//Stream.cons(head,stream) becomes head::stream
//I think 2.8 will have #::
class PrettyStream[A](str: =>Stream[A]) {
    def ::(hd: A) = Stream.cons(hd, str)
}
implicit def streamToPrettyStream[A](str: =>Stream[A]) = new PrettyStream(str)

def fib: Stream[Int] = 0 :: 1 :: fib.zip(fib.tail).map{case (a,b) => a + b}
