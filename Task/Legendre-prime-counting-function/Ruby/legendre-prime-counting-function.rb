require 'prime'

def pi(n)
  @pr = Prime.each(Integer.sqrt(n)).to_a
  a = @pr.size
  case n
    when 0,1 then 0
    when 2 then 1
    else phi(n,a) + a - 1
  end
end

def phi(x,a)
  case a
    when 0 then x
    when 1 then x-(x>>1)
    else
    pa = @pr[a-1]
    return 1 if x <= pa
    phi(x, a-1)- phi(x/pa, a-1)
  end
end

(0..9).each {|n| puts "10E#{n} #{pi(10**n)}" }
