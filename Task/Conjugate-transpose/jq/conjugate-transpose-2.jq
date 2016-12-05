# x must be real or complex, and ditto for y;
# always return complex
def plus(x; y):
    if (x|type) == "number" then
       if  (y|type) == "number" then [ x+y, 0 ]
       else [ x + y[0], y[1]]
       end
    elif (y|type) == "number" then plus(y;x)
    else [ x[0] + y[0], x[1] + y[1] ]
    end;

# x must be real or complex, and ditto for y;
# always return complex
def multiply(x; y):
    if (x|type) == "number" then
       if  (y|type) == "number" then [ x*y, 0 ]
       else [x * y[0], x * y[1]]
       end
    elif (y|type) == "number" then multiply(y;x)
    else [ x[0] * y[0] - x[1] * y[1],  x[0] * y[1] + x[1] * y[0]]
    end;

# conjugate of a real or complex number
def conjugate:
  if type == "number" then [.,0]
  else [.[0], -(.[1]) ]
  end;
