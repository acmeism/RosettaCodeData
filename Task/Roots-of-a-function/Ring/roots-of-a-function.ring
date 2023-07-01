load "stdlib.ring"
function = "return pow(x,3)-3*pow(x,2)+2*x"
rangemin = -1
rangemax = 3
stepsize = 0.001
accuracy = 0.1
roots(function, rangemin, rangemax, stepsize, accuracy)

func roots funct, min, max, inc, eps
     oldsign = 0
     for x = min to max step inc
         num = sign(eval(funct))
         if num = 0
            see "root found at x = " + x + nl
            num = -oldsign
         else if num != oldsign and oldsign != 0
              if inc < eps
                 see "root found near x = " + x + nl
              else roots(funct, x-inc, x+inc/8, inc/8, eps) ok ok ok
         oldsign = num
     next
