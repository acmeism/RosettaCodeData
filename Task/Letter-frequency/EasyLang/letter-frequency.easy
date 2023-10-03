len d[] 26
repeat
   s$ = input
   until s$ = ""
   for c$ in strchars s$
      c = strcode c$
      if c >= 97 and c <= 122
         c -= 32
      .
      if c >= 65 and c <= 91
         d[c - 64] += 1
      .
   .
.
for i to 26
   write strchar (96 + i) & ": "
   print d[i]
.
input_data
Open a text file and count the occurrences of each letter.
Some of these programs count all characters (including
punctuation), but some only count letters A to Z.
Other tasks related to string operations:
