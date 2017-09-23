a = .set~of("John", "Bob", "Mary", "Serena")
b = .set~of("Jim", "Mary", "John", "Bob")
-- the xor operation is a symmetric difference
do item over a~xor(b)
   say item
end
