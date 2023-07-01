class Array
  def bind(f)
    flat_map(&f)
  end
  def self.unit(*args)
    args
  end
  # implementing lift is optional, but is a great helper method for turning
  # ordinary funcitons into monadic versions of them.
  def self.lift(f)
    -> e { self.unit(f[e]) }
  end
end

inc = -> n { n + 1 }
str = -> n { n.to_s }
listy_inc = Array.lift(inc)
listy_str = Array.lift(str)

Array.unit(3,4,5).bind(listy_inc).bind(listy_str) #=> ["4", "5", "6"]

# Note that listy_inc and listy_str cannot be composed directly,
# as they don't have compatible type signature.
# Due to duck typing (Ruby will happily turn arrays into strings),
#   in order to show this, a new function will have to be used:

doub = -> n { 2*n }
listy_doub = Array.lift(doub)
[3,4,5].bind(listy_inc).bind(listy_doub) #=> [8, 10, 12]

# Direct composition will cause a TypeError, as Ruby cannot evaluate 2*[4, 5, 6]
# Using bind with the composition is *supposed* to fail, no matter the programming language.
comp = -> f, g {-> x {f[g[x]]}}
[3,4,5].bind(comp[listy_doub, listy_inc]) #=> TypeError: Array can't be coerced into Fixnum

# Composition needs to be defined in terms of bind
class Array
  def bind_comp(f, g)
    bind(g).bind(f)
  end
end

[3,4,5].bind_comp(listy_doub, listy_inc) #=> [8, 10, 12]
