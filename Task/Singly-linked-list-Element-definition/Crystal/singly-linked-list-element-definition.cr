class Node (T)
  property data : T
  property next : Node(T)?

  def initialize (@data, @next = nil)
  end
end
