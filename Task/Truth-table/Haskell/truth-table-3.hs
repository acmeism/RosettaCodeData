λ> putStr $ truthTable $ toRPN "(Human => Mortal) & (Socratus => Human) => (Socratus => Mortal)"

Human  Mortal Socratus result
True   True   True     True
True   True   False    True
True   False  True     True
True   False  False    True
False  True   True     True
False  True   False    True
False  False  True     True
False  False  False    True
