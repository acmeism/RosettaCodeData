succ = proc{|x| x+1}
def to2(&f)
  f[2]
end

to2(&succ) #=> 3
to2{|x| x+1} #=> 3
