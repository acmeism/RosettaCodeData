#!/usr/local/bin/apl -s --

∇r←b FlipRow ix             ⍝ Flip a row
        r←b
        r[ix;]←~r[ix;]
∇

∇r←b FlipCol ix             ⍝ Flip a column
        r←b
        r[;ix]←~r[;ix]
∇

∇r←RandFlip b;ix            ⍝ Flip a random row or column
        ix←?↑⍴b
        →(2|?2)/col
        r←b FlipRow ix ⋄ →0
col:    r←b FlipCol ix
∇

∇s←ttl ShowBoard b;d        ⍝ Add row, column indices and title to board
        s←'-'⍪⍕(' ',⎕UCS 48+d),(⎕UCS 64+d←⍳↑⍴b)⍪b
        s←((2⊃⍴s)↑ttl)⍪s
∇

∇b←MkBoard n                ⍝ Generate random board
        b←(?(n,n)⍴2)-1
∇

∇Game;n;board;goal;moves;swaps;in;tgt
        ⍝⍝ Initialize
        ⎕RL←(2*32)|×/⎕TS    ⍝ random seed from time
        →(5≠⍴⎕ARG)/usage    ⍝ check argument
        →(~'0123456789'∧.∊⍨n←5⊃⎕ARG)/usage
        →((3>n)∨8<n←⍎n)/usage
        board←goal←MkBoard n    ⍝ Make a random board of the right size
        swaps←4+?16             ⍝ 5 to 20 swaps
        board←(RandFlip⍣swaps)board
        moves←0
        ⎕←'*** Flip the bits! ***'
        ⎕←'----------------------'


        ⍝⍝ Print game state
state:  ⎕←''
        ⎕←'Swaps:',moves,'   Goal:',swaps
        ⎕←''
        ('Board'ShowBoard board),' ',' ',' ',' ','Goal'ShowBoard goal

        ⍝⍝ Handle move
        ⍞←'Press line or column to flip, or Q to quit: '
read:   in←32⊤∨1⎕FIO[41]1
        →(in=⎕UCS'q')/0
        →((97≤in)∧(tgt←in-96)≤n)/col
        →((49≤in)∧(tgt←in-48)≤n)/row
        →read
col:    ⍞←⎕UCS in ⋄ board←board FlipCol tgt ⋄ →check
row:    ⍞←⎕UCS in ⋄ board←board FlipRow tgt

        ⍝⍝ Check if player won
check:  →(board≡goal)/win
        moves←moves+1
        →state
win:    ⎕←'You win!'
        →0
usage:  ⎕←'Usage:',⎕ARG[4],'[3..8]; number is board size.'
∇
Game
)OFF
