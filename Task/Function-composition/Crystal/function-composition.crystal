require "math"

def compose(f : Proc(T, _), g : Proc(_, _)) forall T
  return ->(x : T) { f.call(g.call(x)) }
end

compose(->Math.sin(Float64), ->Math.asin(Float64)).call(0.5)  #=> 0.5
