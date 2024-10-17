    :[
        0=#x;           / if length of x is zero
        x;              / then return x
                        / else
        ,/(             / join the results of:
          _f x[&x<p]         / sort (recursively) elements less than pivot p
          x[&x=p]            / elements equal to p
          _f x[&x>p])        / sort (recursively) elements greater than p
     ]
