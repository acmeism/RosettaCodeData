#define foo(type,g,nn) \
typex function g(i);\
typex i,s,n;\
data s,n/0,nn/;\
s=s+i;\
g=s+n;\
end

      foo(real,x,1)
      foo(integer,y,3)

      program acc
      real x, temp
      integer y, itemp
      temp = x(5.0)
      print *, x(2.3)
      itemp = y(5)
      print *, y(2)
      stop
      end
