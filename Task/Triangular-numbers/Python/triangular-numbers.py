from math import comb, sqrt

nth_rsimplex = lambda n,r: comb(n+r-1, r)
dims = [2,3,4,12]
for dim in dims:
    print("First 30 %d-simplex numbers:"%dim)
    print([nth_rsimplex(i+1, dim) for i in range(30)])

rootnums = [7140, 21408696, 26728085384, 14545501785001]

tri_root = lambda x: 0.5*(sqrt(8*x+1)-1)
tet_root = lambda x: (3*x+sqrt(9*x**2-1/27))**(1/3)+(3*x-sqrt(9*x**2-1/27))**(1/3)-1
pent_root = lambda x: 0.5*(sqrt(5+4*sqrt(24*x+1))-3)

for num in rootnums:
    print("Triangular, tetrahedral and pentatopic roots of %d:"%num)
    print([tri_root(num), tet_root(num), pent_root(num)])
