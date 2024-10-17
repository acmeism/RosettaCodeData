def fac(x) # the more efficient tail recursive version...
  facp = -> (fn : Proc(BigInt -> (Int32 -> BigInt))) {
               -> (n : BigInt) { -> (i : Int32) {
                     i < 2 ? n : fn.call.call(i * n).call(i - 1) } } }
  YCombo.new(facp).fixy.call(BigInt.new(1)).call(x)
end

def fib(x) # the more efficient tail recursive version...
  fibp = -> (fn : Proc(BigInt -> (BigInt -> (Int32 -> BigInt)))) {
    -> (f : BigInt) { -> (s : BigInt) { -> (i : Int32) {
          i < 2 ? f : fn.call.call(s).call(f + s).call(i - 1) } } } }
  YCombo.new(fibp).fixy.call(BigInt.new).call(BigInt.new(1)).call(x)
end
