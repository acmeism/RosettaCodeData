Base = 10
N = 6
Paddy_cnt = 1
for n in range(N):
  for V in CastOut(Base,Start=Base**n,End=Base**(n+1)):
    for B in range(n+1,n*2+2):
      x,y = divmod(V*V,Base**B)
      if V == x+y and 0<y:
        print('{1}: {0}'.format(V, Paddy_cnt))
        Paddy_cnt += 1
        break
