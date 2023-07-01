require "random"

first = gets.not_nil!.to_i32
second = gets.not_nil!.to_i32

arr = Array(Array(Int32)).new(first, Array(Int32).new second, 0)

random = Random.new

first = random.rand 0..(first - 1)
second = random.rand 0..(second - 1)

arr[first][second] = random.next_int
puts arr[first][second]
