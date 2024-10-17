require "big"

struct RecursiveFunc(T) # a generic recursive function wrapper...
  getter recfnc : RecursiveFunc(T) -> T
  def initialize(@recfnc) end
end

struct YCombo(T) # a struct or class needs to be used so as to be generic...
  def initialize (@fnc : Proc(T) -> T) end
  def fixy
    g = -> (x : RecursiveFunc(T)) {
              @fnc.call(-> { x.recfnc.call(x) }) }
    g.call(RecursiveFunc(T).new(g))
  end
end

def fac(x) # horrendouly inefficient not using tail calls...
  facp = -> (fn : Proc(BigInt -> BigInt)) {
               -> (n : BigInt) { n < 2 ? n : n * fn.call.call(n - 1) } }
  YCombo.new(facp).fixy.call(BigInt.new(x))
end

def fib(x) # horrendouly inefficient not using tail calls...
  facp = -> (fn : Proc(BigInt -> BigInt)) {
               -> (n : BigInt) {
                     n < 3 ? n - 1 : fn.call.call(n - 2) + fn.call.call(n - 1) } }
  YCombo.new(facp).fixy.call(BigInt.new(x))
end

puts fac(10)
puts fib(11) # starts from 0 not 1!
