class Array
  def bubble_sort!
    i = size - 1
    while i > 0
      (1..i).each do |j|
        swap(j, j-1)  if self[j] < self[j-1]
      end
      i -= 1
    end
    self
  end
end

arr = Array.new(20) { rand 100 }

p arr
p arr.bubble_sort!
