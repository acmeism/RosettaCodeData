require 'prime'

p (1..200).select{|n| [2, 3].all?{|base| n.digits(base).sum.prime?} }
