epsilon=:3 :0''
  epsilon=. 1.0
  while. 1.0 ~: 1.0 + epsilon do.
    epsilon=. epsilon % 2.0
  end.
)

a=: 1.0
b=: epsilon
c=: -epsilon

KahanSum=:3 :0
  input=. y
  c=. 0.0
  sum=. 0.0
  for_i. i.#input do.
    y=. (i{input) - c
    t=. sum + y
    c=. (t - sum) - y
    sum=. t
  end.
)
