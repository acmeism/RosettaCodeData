# multiplication of real or complex numbers
def cmult(x; y):
    if (x|type) == "number" then
       if  (y|type) == "number" then [ x*y, 0 ]
       else [x * y[0], x * y[1]]
       end
    elif (y|type) == "number" then cmult(y;x)
    else [ x[0] * y[0] - x[1] * y[1],  x[0] * y[1] + x[1] * y[0]]
    end;

def cplus(x; y):
    if (x|type) == "number" then
       if  (y|type) == "number" then [ x+y, 0 ]
       else [ x + y[0], y[1]]
       end
    elif (y|type) == "number" then cplus(y;x)
    else [ x[0] + y[0], x[1] + y[1] ]
    end;

def cminus(x; y): cplus(x; cmult(-1; y));

# e(ix) = cos(x) + i sin(x)
def expi(x): [ (x|cos), (x|sin) ];
