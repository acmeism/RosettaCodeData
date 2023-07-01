def ng (sailors)
  def _ng (sailors, iter, start) #a method that given a possible answer applies the constraints of the tale to see if it is correct
    n, g = [start], [start/sailors]
    (1..iter).each{|s|
      g[s],rem = n[s-1].divmod(sailors-1)
      rem > 0 ? (return false) : n[s] = g[s]*sailors + 1
    }
    return [n,g]
  end
  n, start, step = [], sailors*(sailors-1), 1
  (2..sailors).each{|s|
    g=0; until n=_ng(sailors,s,start + g*step*sailors*(sailors-1)) do g+=1 end
    start,step = n[0][0], step*(sailors-1)
  }
  return n
end
