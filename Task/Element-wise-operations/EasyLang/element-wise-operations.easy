func[][] smul m[][] a .
   for i to len m[][] : for j to len m[i][]
      m[i][j] *= a
   .
   return m[][]
.
func[][] sdiv m[][] a .
   return smul m[][] (1 / a)
.
func[][] sadd m[][] a .
   for i to len m[][] : for j to len m[i][]
      m[i][j] += a
   .
   return m[][]
.
func[][] ssub m[][] a .
   return sadd m[][] -a
.
func[][] spow m[][] a .
   for i to len m[][] : for j to len m[i][]
      m[i][j] = pow m[i][j] a
   .
   return m[][]
.
func[][] mmul m[][] n[][] .
   for i to len m[][] : for j to len m[i][]
      m[i][j] *= n[i][j]
   .
   return m[][]
.
func[][] mdiv m[][] n[][] .
   for i to len m[][] : for j to len m[i][]
      m[i][j] /= n[i][j]
   .
   return m[][]
.
func[][] madd m[][] n[][] .
   for i to len m[][] : for j to len m[i][]
      m[i][j] += n[i][j]
   .
   return m[][]
.
func[][] msub m[][] n[][] .
   for i to len m[][] : for j to len m[i][]
      m[i][j] -= n[i][j]
   .
   return m[][]
.
func[][] mpow m[][] n[][] .
   for i to len m[][] : for j to len m[i][]
      m[i][j] = pow m[i][j] n[i][j]
   .
   return m[][]
.
m[][] = [ [ 5 3 ] [ 4 2 ] ]
n[][] = [ [ 1 2 ] [ 7 8 ] ]
#
print smul m[][] 2
print sdiv m[][] 2
print sadd m[][] 2
print ssub m[][] 2
print spow m[][] 2
print mmul m[][] n[][]
print mdiv m[][] n[][]
print madd m[][] n[][]
print msub m[][] n[][]
print mpow m[][] n[][]
