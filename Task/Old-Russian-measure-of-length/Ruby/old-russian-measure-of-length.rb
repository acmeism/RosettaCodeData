module Distances

  RATIOS =
  {arshin: 0.7112, centimeter: 0.01,     diuym:   0.0254,
   fut:    0.3048, kilometer:  1000.0,   liniya:  0.00254,
   meter:  1.0,    milia:      7467.6,   piad:    0.1778,
   sazhen: 2.1336, tochka:     0.000254, vershok: 0.04445,
   versta: 1066.8}

  def self.method_missing(meth, arg)
    from, to = meth.to_s.split("2").map(&:to_sym)
    raise NoMethodError, meth if ([from,to]-RATIOS.keys).size > 0
    RATIOS[from] * arg / RATIOS[to]
  end

  def self.print_others(name, num)
    puts "#{num} #{name} ="
    RATIOS.except(name.to_sym).each {|k,v| puts "#{ (1.0 / v*num)} #{k}" }
  end
end

Distances.print_others("meter", 2)
puts
p Distances.meter2centimeter(3)
p Distances.arshin2meter(1)
p Distances.versta2kilometer(20) # en Hoeperdepoep zat op de stoep
# 13*13 = 169 methods supported, but not:
p Distances.mile2piad(1)
