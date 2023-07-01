import std

// derived from JAMA v1.03

// rectangular input array A is transformed in place to LU form

def LUDecomposition(LU):
   // Use a "left-looking", dot-product, Crout/Doolittle algorithm.
   let m = LU.length
   let n = LU[0].length
   let piv = map(m): _
   var pivsign = 1
   let LUcolj = map(m): 0.0
   // Outer loop.
   for(n) j:
      // Make a copy of the j-th column to localize references
      for(m) i:
         LUcolj[i] = LU[i][j]
      // Apply previous transformations
      for(m) i:
         let LUrowi = LU[i]
         // Most of the time is spent in the following dot product
         let kmax = min(i,j)
         var s = 0.0
         for(kmax) k:
            s += LUrowi[k] * LUcolj[k]
         s = LUcolj[i] - s
         LUcolj[i] = s
         LUrowi[j] = s
      // Find pivot and exchange if necessary.
      var p = j
      var i = j+1
      while i < m:
         if abs(LUcolj[i]) > abs(LUcolj[p]):
            p = i
         i += 1
      if p != j:
         for(n) k:
            let t = LU[p][k]
            LU[p][k] = LU[j][k]
            LU[j][k] = t
         let k = piv[p]
         piv[p] = piv[j]
         piv[j] = k
         pivsign = -pivsign
      // Compute multipliers.
      if j < m and LU[j][j] != 0.0:
         i = j+1
         while i < m:
            LU[i][j] /= LU[j][j]
            i += 1
   return piv

def print_A(A):
   print "A:"
   for(A) row:
      print row

def print_L(LU):
   print "L:"
   for(LU) lurow, i:
      let row = map(lurow.length): 0.0
      for(lurow) x, j:
         if i > j:
            row[j] = x
         else: if i == j:
            row[j] = 1.0
      print row

def print_U(LU):
   print "U:"
   for(LU) lurow, i:
      let row = map(lurow.length): 0.0
      for(lurow) x, j:
         if i <= j:
            row[j] = x
      print row

def print_P(piv):
   print "P:"
   for(piv) j:
      let row = map(piv.length): 0
      row[j] = 1
      print row

var A = [[1., 3., 5.],
         [2., 4., 7.],
         [1., 1., 0.]]

print_A A
var piv = LUDecomposition(A)
print_L A
print_U A
print_P piv

A = [[11.,  9., 24., 2.],
     [ 1.,  5.,  2., 6.],
     [ 3., 17., 18., 1.],
     [ 2.,  5.,  7., 1.]]

print_A A
piv = LUDecomposition(A)
print_L A
print_U A
print_P piv
