function solve(angle, maxlen, filter)
  local squares, roots, solutions = {}, {}, {}
  local cos2 = ({[60]=-1,[90]=0,[120]=1})[angle]
  for i = 1, maxlen do squares[i], roots[i^2] = i^2, i end
  for a = 1, maxlen do
    for b = a, maxlen do
      local lhs = squares[a] + squares[b] + cos2*a*b
      local c = roots[lhs]
      if c and (not filter or filter(a,b,c)) then
        solutions[#solutions+1] = {a=a,b=b,c=c}
      end
    end
  end
  print(angle.."° on 1.."..maxlen.." has "..#solutions.." solutions")
  if not filter then
    for i,v in ipairs(solutions) do print("",v.a,v.b,v.c) end
  end
end
solve(90, 13)
solve(60, 13)
solve(120, 13)
function fexcr(a,b,c) return a~=b or b~=c end
solve(60, 10000, fexcr)  -- extra credit
solve(90, 10000, fexcr)  -- more extra credit
solve(120, 10000, fexcr) -- even more extra credit
