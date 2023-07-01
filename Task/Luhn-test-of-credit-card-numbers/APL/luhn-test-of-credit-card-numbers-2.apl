    ∇ ret←LuhnTest num;s1;s2
[1]   num←⌽((⌈10⍟num)/10)⊤num
[2]   s1←+/((⍴num)⍴1 0)/num
[3]   s2←+/∊(⊂10 10)⊤¨2×((⍴num)⍴0 1)/num
[4]   ret←0=10⊤s1+s2
    ∇
