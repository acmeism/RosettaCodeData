class Node (T)
  property data : T
  property next : Node(T)?

  def initialize (@data, @next = nil)
  end

  def insert_after (new_data)
    n = Node.new(new_data, @next)
    @next = n
  end

  def to_s (io)
    io << data << "->"
    if @next
      @next.to_s(io)
    else
      io << "."
    end
  end
end

n = Node.new('A', Node.new('B', Node.new('D')))
puts n
n.insert_after('C')
puts n
