out←doorsOptimized num;marks
⍝ Returns a boolean vector of the doors that would be left open

marks←⌊num*0.5        ⍝ Take the square root of the size, floored
marks←(⍳marks)*2      ⍝ Get each door to be opened
out←num⍴0             ⍝ Make a vector of 0s
out[marks]←1          ⍝ Set the marked doors to 1
