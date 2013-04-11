def sierpinski_triangle(n)

    (0..(n-1)).inject(["*"]) {|triangle, i|
	space = " " * (2**i)
	triangle.map {|x| space + x + space} + triangle.map {|x| x + " " + x}
    }
end

puts sierpinski_triangle(4)
