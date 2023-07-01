require 'trit'
maybe = MAYBE

[true, maybe, false].each do |a|
  [true, maybe, false].each do |b|
    printf "%5s ^ %5s => %5s\n", a, b, a.trit ^ b
  end
end
