require 'thread'

# Simple Semaphore implementation
class Semaphore
  def initialize(size = 1)
    @queue = SizedQueue.new(size)
    size.times { acquire }
  end

  def acquire
    tap { @queue.push(nil) }
  end

  def release
    tap { @queue.pop }
  end

  # @return [Integer]
  def count
    @queue.length
  end

  def synchronize
    release
    yield
  ensure
    acquire
  end
end

def foo(id, sem)
  sem.synchronize do
    puts "Thread #{id} Acquired lock"
    sleep(2)
  end
end

threads = []
n = 5
s = Semaphore.new(3)
n.times do |i|
  threads << Thread.new { foo i, s }
end
threads.each(&:join)
