: hypot ( a b -- a^2 + b^2 )
  LOCALS| b a |            \ note: reverse order from the conventional stack comment
  b b * a a * + ;
