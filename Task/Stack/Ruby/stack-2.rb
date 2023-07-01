require 'forwardable'

# A stack contains elements in last-in, first-out order.
# Stack#push adds new elements to the top of the stack;
# Stack#pop removes elements from the top.
class Stack
  extend Forwardable

  # Creates a Stack containing _objects_.
  def self.[](*objects)
    new.push(*objects)
  end

  # Creates an empty Stack.
  def initialize
    @ary = []
  end

  # Duplicates a Stack.
  def initialize_copy(obj)
    super
    @ary = @ary.dup
  end

  # Adds each object to the top of this Stack. Returns self.
  def push(*objects)
    @ary.push(*objects)
    self
  end
  alias << push

  ##
  # :method: pop
  # :call-seq:
  #   pop -> obj or nil
  #   pop(n) -> ary
  #
  # Removes an element from the top of this Stack, and returns it.
  # Returns nil if the Stack is empty.
  #
  # If passing a number _n_, removes the top _n_ elements, and returns
  # an Array of them. If this Stack contains fewer than _n_ elements,
  # returns them all. If this Stack is empty, returns an empty Array.
  def_delegator :@ary, :pop

  ##
  # :method: top
  # :call-seq:
  #   top -> obj or nil
  #   top(n) -> ary
  # Returns the topmost element without modifying the stack.
  def_delegator :@ary, :last, :top

  ##
  # :method: empty?
  # Returns true if this Stack contains no elements.
  def_delegator :@ary, :empty?

  ##
  # :method: size
  # Returns the number of elements in this Stack.
  def_delegator :@ary, :size
  alias length size

  # Converts this Stack to a String.
  def to_s
    "#{self.class}#{@ary.inspect}"
  end
  alias inspect to_s
end
