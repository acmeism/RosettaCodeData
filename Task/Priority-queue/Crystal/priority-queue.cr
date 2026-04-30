class Heap (T)
  @heap : Array(T)

  def initialize (source : Array(T) = [] of T)
    @heap = source.dup
    heapify
  end

  def << (item)
    @heap << item
    siftup @heap.size - 1
    self
  end

  def push (item)
    self << item
  end

  def shift
    new_head = @heap.pop
    return new_head if @heap.empty?
    result = @heap[0]
    @heap[0] = new_head
    siftdown 0
    result
  end

  def empty?
    @heap.empty?
  end

  def to_s (io)
    io << "Heap"
    @heap.to_s io
  end

  private def heapify
    (@heap.size//2 - 1).downto(0) do |i|
      siftdown i
    end
  end

  private def siftdown (i)
    n = @heap.size
    loop do
      j = i*2 + 1
      return  if j >= n
      j += 1  if j+1 < n && @heap[j+1] < @heap[j]
      return  if @heap[i] <= @heap[j]
      @heap.swap i, j
      i = j
    end
  end

  private def siftup (i)
    loop do
      j = (i-1)//2
      break unless j >= 0 && @heap[i] < @heap[j]
      @heap.swap i, j
      i = j
    end
  end
end

tasks = [{3, "Clear drains"}, {4, "Feed cat"}, {5, "Make tea"},
         {1, "Solve RC tasks"}, {2, "Tax return"}]

heap = Heap.new tasks

while !heap.empty?
  puts heap.shift
end
