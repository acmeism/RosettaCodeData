C This one implements depth-first backtracking.
C See the 2nd program for Scheme on the "Permutations" page for the
C main idea.
C As is, the program only prints the number of n-queens configurations.
C To print also the configurations, uncomment the line after label 80.
      program queens
      implicit integer(a-z)
      parameter(l=18)
      dimension a(l),s(l),u(4*l-2)
      do 10 i=1,l
   10 a(i)=i
      do 20 i=1,4*l-2
   20 u(i)=0
      do 110 n=1,l
      m=0
      i=1
      r=2*n-1
      go to 40
   30 s(i)=j
      u(p)=1
      u(q+r)=1
      i=i+1
   40 if(i.gt.n) go to 80
      j=i
   50 z=a(i)
      y=a(j)
      p=i-y+n
      q=i+y-1
      a(i)=y
      a(j)=z
      if((u(p).eq.0).and.(u(q+r).eq.0)) goto 30
   60 j=j+1
      if(j.le.n) go to 50
   70 j=j-1
      if(j.eq.i) go to 90
      z=a(i)
      a(i)=a(j)
      a(j)=z
      go to 70
   80 m=m+1
C     print *,(a(k),k=1,n)
   90 i=i-1
      if(i.eq.0) go to 100
      p=i-a(i)+n
      q=i+a(i)-1
      j=s(i)
      u(p)=0
      u(q+r)=0
      go to 60
  100 print *,n,m
  110 continue
      end

C Output
C          1           1
C          2           0
C          3           0
C          4           2
C          5          10
C          6           4
C          7          40
C          8          92
C          9         352
C         10         724
C         11        2680
C         12       14200
C         13       73712
C         14      365596
C         15     2279184
C         16    14772512
C         17    95815104
C         18   666090624
