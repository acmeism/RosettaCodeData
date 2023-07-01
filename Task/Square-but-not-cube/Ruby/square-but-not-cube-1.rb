#!/usr/bin/env ruby

class PowIt
	:next
	
	def initialize
		@next = 1;
	end
end

class SquareIt < PowIt
	def next
		result = @next ** 2
		@next += 1
		return result
	end
end

class CubeIt < PowIt
	def next
		result = @next ** 3
		@next += 1
		return result
	end
end

squares = []
hexponents = []

squit = SquareIt.new
cuit = CubeIt.new

s = squit.next
c = cuit.next

while (squares.length < 30 || hexponents.length < 3)
	if s < c
		squares.push(s) if squares.length < 30
		s = squit.next
	elsif s == c
		hexponents.push(s) if hexponents.length < 3
		s = squit.next
		c = cuit.next
	else
		c = cuit.next
	end
end

puts "Squares:"
puts squares.join(" ")

puts "Square-and-cubes:"
puts hexponents.join(" ")
