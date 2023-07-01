class PriorityQueueNaive
  def initialize(data=nil)
    @q = Hash.new {|h, k| h[k] = []}
    data.each {|priority, item| @q[priority] << item}  if data
    @priorities = @q.keys.sort
  end

  def push(priority, item)
    @q[priority] << item
    @priorities = @q.keys.sort
  end

  def pop
    p = @priorities[0]
    item = @q[p].shift
    if @q[p].empty?
      @q.delete(p)
      @priorities.shift
    end
    item
  end

  def peek
    unless empty?
      @q[@priorities[0]][0]
    end
  end

  def empty?
    @priorities.empty?
  end

  def each
    @q.each do |priority, items|
      items.each {|item| yield priority, item}
    end
  end

  def dup
    @q.each_with_object(self.class.new) do |(priority, items), obj|
      items.each {|item| obj.push(priority, item)}
    end
  end

  def merge(other)
    raise TypeError  unless self.class == other.class
    pq = dup
    other.each {|priority, item| pq.push(priority, item)}
    pq                  # return a new object
  end

  def inspect
    @q.inspect
  end
end

test = [
  [6, "drink tea"],
  [3, "Clear drains"],
  [4, "Feed cat"],
  [5, "Make tea"],
  [6, "eat biscuit"],
  [1, "Solve RC tasks"],
  [2, "Tax return"],
]

pq = PriorityQueueNaive.new
test.each {|pr, str| pq.push(pr, str) }
until pq.empty?
  puts pq.pop
end

puts
test2 = test.shift(3)
p pq1 = PriorityQueueNaive.new(test)
p pq2 = PriorityQueueNaive.new(test2)
p pq3 = pq1.merge(pq2)
puts "peek : #{pq3.peek}"
until pq3.empty?
  puts pq3.pop
end
puts "peek : #{pq3.peek}"
