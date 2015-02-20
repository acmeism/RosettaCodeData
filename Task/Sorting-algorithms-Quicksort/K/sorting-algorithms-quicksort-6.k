    :[
        0=#x;           / if length of x is zero
        x;              / then return x
                        / else
        ,/(             / join the results of:
          _f x@&x<f         / sort (recursively) elements less than f (pivot)
          x@&x=f            / element equal to f
          _f x@&x>f)        / sort (recursively) elements greater than f
     ]
