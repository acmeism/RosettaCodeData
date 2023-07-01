def det(m,n):
 if n==1: return m[0][0]
 z=0
 for r in range(n):
  k=m[:]
  del k[r]
  z+=m[r][0]*(-1)**r*det([p[1:]for p in k],n-1)
 return z
w=len(t)
d=det(h,w)
if d==0:r=[]
else:r=[det([r[0:i]+[s]+r[i+1:]for r,s in zip(h,t)],w)/d for i in range(w)]
print(r)
