⍝  Copy/paste file's contents into TXT (easiest), or TXT ← ⎕NREAD
       I  ←  TXT[;8+⎕IO]
       D  ←  TXT[;⎕IO+14+⍳19]
       lu ←  +\ ¯1 * 'OI' ⍳ I
       mx ←  (⎕IO+⍳⍴lu)/⍨lu= max ← ⌈/ lu
       ⎕  ←  'Maximum simultaneous license use is ' , ' at the following times:' ,⍨ ⍕max ⋄ ⎕←D[mx;]
