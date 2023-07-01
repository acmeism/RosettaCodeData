⍝  initialize a Langton's Ant setup with a grid of size left x right (square by default)
langton ← {
    ⍝ If rows not specified, set equal to columns
    ⍺ ← ⍵

    ⍝ 0=white, 1=black. Start with all white
    grid ← ⍺ ⍵ ⍴ 0

    ⍝  Start the ant in the middle
    ant ← 2 ÷⍨ ⍺ ⍵

    ⍝  Aimed in a random direction
    dir ← ?4

    ⍝ return everything in a tuple
    grid ant dir
}

⍝  iterate one step: takes and returns state as created by langton function
step ← {
    grid ant dir ← ⍵

    ⍝ Turn left or right based on grid cell
    dir ← 1 + 4|dir+2×grid[⊂ant]

    ⍝ Toggle cell color
    grid[⊂ant] ← 1 - grid[⊂ant]

    ⍝ Advance along dir. Since coordinates are matrix order (row,col),
    ⍝ up is -1 0, right is 0 1, down is 1 0, and left is 0 -1
    ant +← (4 2 ⍴ ¯1 0, 0 1, 1 0, 0 ¯1)[dir;]

    grid ant dir
}

⍝ to watch it run, open the variable pic in the monitor before executing this step
{} { state ∘← ⍵ ⋄ pic ∘← '.⌺'[1+⊃1⌷⍵] ⋄ _←⎕dl ÷200 ⋄ step ⍵} ⍣≡ langton 100
