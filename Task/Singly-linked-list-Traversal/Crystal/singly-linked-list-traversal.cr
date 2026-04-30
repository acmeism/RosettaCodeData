class Node (T)
  include Enumerable(T)

  property data : T
  property next : Node(T)?

  def initialize (@data, @next = nil)
  end

  def each
    node = self
    while node
      yield node.data
      node = node.next
    end
  end
end

list = Node.new('A', Node.new('B', Node.new('C')))

list.each_with_index do |ch, i|
  puts "#{i}. #{ch}"
end
