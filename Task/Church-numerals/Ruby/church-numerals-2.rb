Zero  = proc { |f| proc { |x| x } }

Succ = proc { |n| proc { |f| proc { |x| f[n[f][x]] } } }

Add = proc { |n, m| proc { |f| proc { |x| m[f][n[f][x]] } } }

Mult = proc { |n, m| proc { |f| proc { |x| m[n[f]][x] } } }

Power = proc { |b, e| e[b] }

ToInt = proc { |f| countup = proc { |i| i+1 }; f[countup][0] }

FromInt = proc { |x|
  countdown = proc { |i|
    case i
      when 0 then Zero
      else Succ[countdown[i-1]]
    end
  }
  countdown[x]
}

Three = Succ[Succ[Succ[Zero]]]
Four  = FromInt[4]

puts [ Add[Three, Four],
       Mult[Three, Four],
       Power[Three, Four],
       Power[Four, Three] ].map(&ToInt)
