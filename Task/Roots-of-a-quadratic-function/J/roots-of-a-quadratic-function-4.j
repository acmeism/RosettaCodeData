q_r=: verb define
  'a b c' =. y
  q=. b %~ %: a * c
  f=. 0.5 + 0.5 * %:(1-4*q*q)
  (-b*f%a),(-c%b*f)
)

   q_r 1 _1e6 1
1e6 1e_6
