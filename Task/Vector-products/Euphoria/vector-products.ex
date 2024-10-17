constant X = 1, Y = 2, Z = 3

function dot_product(sequence a, sequence b)
    return a[X]*b[X] + a[Y]*b[Y] + a[Z]*b[Z]
end function

function cross_product(sequence a, sequence b)
    return { a[Y]*b[Z] - a[Z]*b[Y],
             a[Z]*b[X] - a[X]*b[Z],
             a[X]*b[Y] - a[Y]*b[X] }
end function

function scalar_triple(sequence a, sequence b, sequence c)
    return dot_product( a, cross_product( b, c ) )
end function

function vector_triple( sequence a, sequence b, sequence c)
    return cross_product( a, cross_product( b, c ) )
end function

constant a = { 3, 4, 5 }, b = { 4, 3, 5 }, c = { -5, -12, -13 }

puts(1,"a = ")
? a
puts(1,"b = ")
? b
puts(1,"c = ")
? c
puts(1,"a dot b = ")
? dot_product( a, b )
puts(1,"a x b = ")
? cross_product( a, b )
puts(1,"a dot (b x c) = ")
? scalar_triple( a, b, c )
puts(1,"a x (b x c) = ")
? vector_triple( a, b, c )
