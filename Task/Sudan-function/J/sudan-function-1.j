F=: {{ 'N X Y'=. y assert. N>:0
  if. 0=N do. X+Y
  elseif. Y=0 do. X
  else. F (N-1),(F N,X,Y-1), Y+F N, X, Y-1
  end.
}}"1
