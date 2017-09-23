⍝returns 1 if leapyear, 0 otherwise:
∇Z←LEAPYEAR YEAR
Z←(0=4|YEAR)∧(0=400|YEAR)∨~0=100|YEAR
∇
