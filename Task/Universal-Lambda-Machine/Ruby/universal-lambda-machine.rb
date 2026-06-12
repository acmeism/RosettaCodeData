#!/usr/bin/ruby
def bit2lam(bit)
  return lambda { |x0| lambda { |x1| bit==0 ? x0 : x1 } }
end
def byte2lam(bits,n)
  return n==0 ? lambda { |_| lambda { |y| y } }
              : lambda { |z| z.call(bit2lam((bits>>(n-1))&1)).call(byte2lam(bits,n-1)) }
end
def input(n)             # input from n'th character onward
  if n >= $inp.length()
    c = STDIN.getbyte
    $inp.append(c==nil ? (lambda { |_| lambda { |y| y } })
                       : lambda { |z| z.call($bytemode ? byte2lam(c,8) : bit2lam(c&1)).call(input(n+1)) } )
  end
  return $inp[n]
end
def lam2bit(lambit)
  return lambit.call(lambda { |_| 0 }).call(lambda { |_| 1 }).call(0)  # force suspension
end
def lam2byte(lambits, x)
  return lambits.call(lambda { |lambit| lambda { |lamtail| lambda { |_| lam2byte(lamtail, 2*x+lam2bit(lambit)) } } }).call(x)
end
def output(prog)
  return prog.call(lambda { |c| putc($bytemode ? lam2byte(c,0) : (lam2bit(c)==0 ? '0' : '1')) and (lambda { |tail| lambda { |_| output(tail) } }) }).call(0)
end
def getbit()
  if ($nbit==0)
    $progchar = STDIN.getbyte
    $nbit = $bytemode ? 8 : 1
  end
  return ($progchar >> $nbit -= 1) & 1
end
def program()
  if getbit()==1                 # variable
    i = 0
    while (getbit()==1) do i += 1 end
    return lambda { |*args| args[i] }
  elsif getbit()==1          # application
    p = program()
    q = program()
    return lambda { |*args| p.call(*args).call(lambda { |arg| q.call(*args).call(arg) }) }  # suspend argument
  else
    p = program()
    return lambda { |*args| lambda { |arg| p.call(arg, *args) } } # extend environment with one more argument
  end
end
$inp = []
$nbit = $progchar = 0
$bytemode = ARGV.length <= 0
$prog = program().call(0)
output($prog.call(input(0)))             # run program with empty env on input
