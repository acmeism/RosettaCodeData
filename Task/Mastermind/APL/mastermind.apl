#!/usr/local/bin/apl -s -f --

⍝ Define the alphabet
A←'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

⍝ Make ASCII values upper case
∇n←AscUp c
        n←c-32×(c≥97)∧(c≤122)
∇

⍝ Does a list have repeated values?
∇r←Rpts l
        r←(l⍳l)≢⍳⍴l
∇

⍝ Keyboard input using ⎕ and ⍞ doesn't work well using GNU APL in script mode,
⍝ so you kind of have to write your own.
⍝ Read a line of text from the keyboard
∇l←ReadLine up;k;z;data
        data←'' ⋄ csr←0 ⍝ Start out with empty string and cursor at 0

        ⍝⍝⍝ Keyboard input
in:     k←1⎕fio[41]1    ⍝ Read byte from stdin
handle: →(k>127)/skip   ⍝ Unicode is not supported (Wumpus doesn't need it)
        →(k∊8 127)/back ⍝ Handle backspace
        →(k=10)/done    ⍝ Newline = Enter key pressed
        →(k<32)/in      ⍝ For simplicity, disregard terminal control entirely

        k←(AscUp⍣up)k   ⍝ Make key uppercase if necessary
        z←k⎕fio[42]0    ⍝ Echo key to stdout
        data←data,k     ⍝ Insert key into data
        →in             ⍝ Go get next key

        ⍝⍝⍝ Skip UTF-8 input (read until byte ≤ 127)
skip:   k←1⎕fio[41]1 ⋄ →(k>127)/skip ⋄ →handle

        ⍝⍝ Backspace
back:   →(0=⍴data)/in   ⍝ If already at beginning, ignore
        z←k⎕fio[42]0    ⍝ Backspace to terminal
        data←¯1↓data    ⍝ Remove character
        →in             ⍝ Get next key

        ⍝⍝ We are done, return the line as text
done:   l←⎕UCS data
∇

⍝ Read a positive number from the keyboard in the range [min...max]
∇n←min ReadNum max;l;z
in:     l←ReadLine 0
        z←10⎕fio[42]0
        →(~l∧.∊'0123456789')/no
        →((min≤n)∧max≥n←⍎l)/0
no:     ⍞←'Please enter a number between ',(⍕min),' and ',(⍕max),': '
        →in
∇

⍝ Ask a numeric question
∇n←q Question lim;min;max
        (min max)←lim
        ⍞←q,' [',(⍕min),'..',(⍕max),']? '
        n←min ReadNum max
∇

⍝ Read a choice from the keyboard
∇c←Choice cs;ks;k;z
        ks←AscUp ⎕UCS ↑¨cs              ⍝ User should press first letter of choice
in:     →(~(k←AscUp 1⎕fio[41]1)∊ks)/in  ⍝ Wait for user to make choice
        z←(c←⊃cs[↑ks⍳k])⎕fio[42]0       ⍝ Select and output correspoinding choice
∇

⍝ Ask the user for game parameters
∇parms←InitGame;clrs;len;gss;rpts
        ⎕←'∘∘∘ MASTERMIND ∘∘∘' ⋄ ⎕←''
        clrs←'How many colors' Question 2 20
        len←'Code length' Question 4 10
        gss←'Maximum amount of guesses' Question 7 20
        ⍞←'Allow repeated colors in code (Y/N)? '
        rpts←'Yes'≡Choice 'Yes' 'No'
        parms←clrs len gss rpts
∇

⍝ Generate a code.
∇c←rpts MakeCode parms;clrs;len
        (clrs len)←parms
        c←A[(1+rpts)⊃(len?clrs)(?len/clrs)]
∇

⍝ Let user make a guess and handle errors
∇g←parms Guess code;clrs;rpts;l;right;in
        (clrs rpts num)←parms

guess:  ⍞←'Guess ',(¯2↑⍕num),': ' ⋄ g←ReadLine 1      ⍝ Read a guess from the keyboard

        ⍝ Don't count obvously invalid input against the user
        →((⍴code)≢⍴g)/len               ⍝ Length is wrong
        →(~g∧.∊A[⍳clrs])/inv            ⍝ Invalid code in input
        →((~rpts)∧Rpts g)/rpt           ⍝ No repeats allowed

        ⍝ Give feedback
        right←g=code                    ⍝ Colors in right position
        in←g∊code                       ⍝ Colors not in right position
        fb←(+/right)/'X'                ⍝ X = amount of matching ones
        fb←fb,(+/in∧~right)/'O'         ⍝ O = amount of non-matching ones
        fb←fb,(+/~in)/'-'               ⍝ - = amount of colors not in code
        ⍞←' --→ ',fb,⎕UCS 10
        →0
len:    ⎕←'Invalid length.' ⋄ →guess
inv:    ⎕←'Invalid color.' ⋄ →guess
rpt:    ⎕←'No repeats allowed.' ⋄ →guess
∇

⍝ Play the game
∇ Mastermind;clrs;len;gsmax;rpts;code;gs
        ⎕rl←(2*32)|×/⎕ts                ⍝ initialize random seed
        (clrs len gsmax rpts)←InitGame
        code←rpts MakeCode clrs len
        ⎕←2 0⍴''
        ⎕←'The code consists of: ',A[⍳clrs]
        gs←0
loop:   gs←gs+1
        →(gs>gsmax)/lose
        →(code≢(clrs rpts gs)Guess code)/loop
        ⎕←'○○○ Congratulations! ○○○'
        ⎕←'You won in ',(⍕gs),' guesses.'
        →0
lose:   ⎕←'Alas, you are out of guesses.'
        ⎕←'The code was: ',code
∇

Mastermind
)OFF
