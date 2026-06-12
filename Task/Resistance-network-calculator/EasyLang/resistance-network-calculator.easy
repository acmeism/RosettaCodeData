func[] gauss m[][] .
   n = len m[][]
   p = len m[1][]
   for i to n
      max = 0
      for j = i to n
         if abs m[j][i] > max
            k = i
            max = m[j][i]
         .
      .
      swap m[i][] m[k][]
      t = 1 / m[i][i]
      for j = i + 1 to p
         m[i][j] *= t
      .
      for j = i + 1 to n
         t = m[j][i]
         for k = i + 1 to p
            m[j][k] -= t * m[i][k]
         .
      .
   .
   for i = n downto 1
      for j to i - 1
         m[j][p] -= m[j][i] * m[i][p]
      .
   .
   for r to n
      r[] &= m[r][p]
   .
   return r[]
.
proc network n k0 k1 s$ .
   len m[][] n
   for i to n
      len m[i][] n + 1
   .
   for resistor$ in strsplit s$ "|"
      res[] = number strsplit resistor$ " "
      a = res[1] + 1
      b = res[2] + 1
      r = 1 / res[3]
      m[a][a] += r
      m[b][b] += r
      if a > 1
         m[a][b] -= r
      .
      if b > 1
         m[b][a] -= r
      .
   .
   m[k0 + 1][k0 + 1] = 1
   m[k1 + 1][n + 1] = 1
   r[] = gauss m[][]
   print r[k1 + 1]
.
network 7 0 1 "0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8"
network 3 * 3 0 3 * 3 - 1 "0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1"
network 4 * 4 0 4 * 4 - 1 "0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1"
network 4 0 3 "0 1 150|0 2 50|1 3 300|2 3 250"
