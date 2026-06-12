[10, 20, 200, 2000].each {|n| puts "#{n}: #{(1..n).inject(&:lcm)}" }
