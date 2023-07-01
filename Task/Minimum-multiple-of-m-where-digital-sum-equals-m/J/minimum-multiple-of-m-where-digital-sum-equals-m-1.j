findfirst=: {{
  ($:@((+1+i.@+:)@#)@[`(+&{. I.)@.(1 e. ]) u) ,1
}}

A131382=: {{y&{{x = sumdigits x*y}} findfirst}}"0

sumdigits=: +/@|:@(10&#.inv)
