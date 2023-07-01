binsrch←{
   ⎕IO(⍺{                       ⍝ first lower bound is start of array
       ⍵<⍺:⍬                    ⍝ if high < low, we didn't find it
       mid←⌊(⍺+⍵)÷2             ⍝ calculate mid point
       ⍺⍺[mid]>⍵⍵:⍺∇mid-1       ⍝ if too high, search from ⍺ to mid-1
       ⍺⍺[mid]<⍵⍵:(mid+1)∇⍵     ⍝ if too low, search from mid+1 to ⍵
       mid                      ⍝ otherwise, we did find it
   }⍵)⎕IO+(≢⍺)-1                ⍝ first higher bound is top of array
}
