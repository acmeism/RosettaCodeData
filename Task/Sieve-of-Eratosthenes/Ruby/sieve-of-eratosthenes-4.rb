require 'prime'
p Prime::EratosthenesGenerator.new.take_while {|i| i <= 100}
