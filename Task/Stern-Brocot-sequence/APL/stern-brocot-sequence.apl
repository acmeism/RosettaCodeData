task←{
   stern←{⍵{
      ⍺←0 ⋄ ⍺⍺≤⍴⍵:⍺⍺↑⍵
      (⍺+1)∇⍵,(+/,2⊃⊣)2↑⍺↓⍵
   }1 1}
   seq←stern 1200 ⍝ Cache 1200 elements
   ⎕←'First 15 elements:',15↑seq
   ⎕←'Locations of 1..10:',seq⍳⍳10
   ⎕←'Location of 100:',seq⍳100
   ⎕←'All GCDs 1:','no' 'yes'[1+1∧.=2∨/1000↑seq]
}
