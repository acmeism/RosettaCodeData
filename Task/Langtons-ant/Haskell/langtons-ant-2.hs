-- functional sequence
(>>>) = flip (.)

-- functional choice
p ?>> (f, g) = \x -> if p x then f x else g x
