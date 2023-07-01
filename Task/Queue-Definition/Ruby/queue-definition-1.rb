require 'forwardable'

# A FIFO queue contains elements in first-in, first-out order.
# FIFO#push adds new elements to the end of the queue;
# FIFO#pop or FIFO#shift removes elements from the front.
class FIFO
  extend Forwardable

  # Creates a FIFO containing _objects_.
  def self.[](*objects)
    new.push(*objects)
  end

  # Creates an empty FIFO.
  def initialize; @ary = []; end

  # Appends _objects_ to the end of this FIFO. Returns self.
  def push(*objects)
    @ary.push(*objects)
    self
  end
  alias << push
  alias enqueue push

  ##
  # :method: pop
  # :call-seq:
  #   pop -> obj or nil
  #   pop(n) -> ary
  #
  # Removes an element from the front of this FIFO, and returns it.
  # Returns nil if the FIFO is empty.
  #
  # If passing a number _n_, removes the first _n_ elements, and returns
  # an Array of them. If this FIFO contains fewer than _n_ elements,
  # returns them all. If this FIFO is empty, returns an empty Array.
  def_delegator :@ary, :shift, :pop
  alias shift pop
  alias dequeue shift

  ##
  # :method: empty?
  # Returns true if this FIFO contains no elements.
  def_delegator :@ary, :empty?

  ##
  # :method: size
  # Returns the number of elements in this FIFO.
  def_delegator :@ary, :size
  alias length size

  # Converts this FIFO to a String.
  def to_s
    "FIFO#{@ary.inspect}"
  end
  alias inspect to_s
end
