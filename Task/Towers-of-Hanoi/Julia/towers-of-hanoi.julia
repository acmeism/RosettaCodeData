function solve(n::Integer, from::Integer, to::Integer, via::Integer)
  if n == 1
    println("Move disk from $from to $to")
  else
    solve(n - 1, from, via, to)
    solve(1, from, to, via)
    solve(n - 1, via, to, from)
  end
end

solve(4, 1, 2, 3)
