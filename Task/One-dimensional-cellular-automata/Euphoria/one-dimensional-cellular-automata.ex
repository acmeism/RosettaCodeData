include machine.e

function rules(integer tri)
    return tri = 3 or tri = 5 or tri = 6
end function

function next_gen(atom gen)
    atom new, bit
    new = rules(and_bits(gen,3)*2) -- work with the first bit separately
    bit = 2
    while gen > 0 do
        new += bit*rules(and_bits(gen,7))
        gen = floor(gen/2) -- shift right
        bit *= 2 -- shift left
    end while
    return new
end function

constant char_clear = '_', char_filled = '#'

procedure print_gen(atom gen)
    puts(1, int_to_bits(gen,32) * (char_filled - char_clear) + char_clear)
    puts(1,'\n')
end procedure

function s_to_gen(sequence s)
    s -= char_clear
    return bits_to_int(s)
end function

atom gen, prev
integer n

n = 0
prev = 0
gen = bits_to_int(rand(repeat(2,32))-1)
while gen != prev do
    printf(1,"Generation %d: ",n)
    print_gen(gen)
    prev = gen
    gen = next_gen(gen)
    n += 1
end while

printf(1,"Generation %d: ",n)
print_gen(gen)
