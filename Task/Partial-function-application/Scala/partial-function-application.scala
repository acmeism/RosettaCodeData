def fs[X](f:X=>X)(s:Seq[X]) = s map f
def f1(x:Int) = x * 2
def f2(x:Int) = x * x

def fsf[X](f:X=>X) = fs(f) _
val fsf1 = fsf(f1) // or without the fsf intermediary: val fsf1 = fs(f1) _
val fsf2 = fsf(f2) // or without the fsf intermediary: val fsf2 = fs(f2) _

assert(fsf1(List(0,1,2,3)) == List(0,2,4,6))
assert(fsf2(List(0,1,2,3)) == List(0,1,4,9))
