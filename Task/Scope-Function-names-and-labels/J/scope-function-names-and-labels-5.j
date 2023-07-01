example=:3 :0
  if. y do.
    echo 0
    goto_a.
    echo 1
  else.
    echo 2
    goto_a.
    echo 3
  end.
  echo 4
  label_a.
  echo 5
)
   example 1
0
5
   example 0
2
5
