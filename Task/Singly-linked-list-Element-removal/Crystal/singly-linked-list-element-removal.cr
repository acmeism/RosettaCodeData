class Node (T)
  property data : T
  property next : Node(T)?

  def initialize (@data, @next = nil)
  end

  def to_s (io)
    io << data << "->"
    if @next
      @next.to_s(io)
    else
      io << "."
    end
  end

  def delete (value)
    if @data == value
      @next
    else
      Node.new @data, (n = @next) && n.delete value
    end
  end
end

list = Node.new('A', Node.new('B', Node.new('C')))
puts list
puts list.delete('B')
