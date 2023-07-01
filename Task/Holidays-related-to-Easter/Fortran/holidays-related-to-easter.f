      subroutine easter(year,month,day)
c Easter sunday
c
c Input
c   year
c Output
c   month
c   day
c
c See:
c Jean Meeus, "Astronomical Formulae for Calculators",
c 4th edition, Willmann-Bell, 1988, p.31
      implicit integer(a-z)
      a=mod(year,19)
      b=year/100
      c=mod(year,100)
      d=b/4
      e=mod(b,4)
      f=(b+8)/25
      g=(b-f+1)/3
      h=mod(19*a+b-d-g+15,30)
      i=c/4
      k=mod(c,4)
      l=mod(32+2*e+2*i-h-k,7)
      m=(a+11*h+22*l)/451
      n=h+l-7*m+114
      month=n/31
      day=mod(n,31)+1
      end
