func giuga m .
   n = m
   for f = 2 to sqrt n
      while n mod f = 0
         if (m div f - 1) mod f <> 0
            return 0
         .
         n = n div f
         if f > n
            return 1
         .
      .
   .
.
n = 3
while cnt < 4
   if giuga n = 1
      cnt += 1
      print n
   .
   n += 1
.
