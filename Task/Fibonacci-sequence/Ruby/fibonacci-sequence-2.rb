def fibRec(n)
  if n <= -2
    (-1)**(n+1) * fibRec(n.abs)
  elsif n <= 1
    n.abs
  else
    fibRec(n-1) + fibRec(n-2)
  end
end
