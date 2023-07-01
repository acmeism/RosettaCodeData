class Permutation
  include Enumerable
  attr_reader :num_elements, :size

  def initialize(num_elements)
    @num_elements = num_elements
    @size = fact(num_elements)
  end

  def each
    return self.to_enum unless block_given?
    (0...@size).each{|i| yield unrank(i)}
  end

  def unrank(r)  # nonrecursive version of Myrvold Ruskey unrank2 algorithm.
    pi = (0...num_elements).to_a
    (@num_elements-1).downto(1) do |n|
      s, r = r.divmod(fact(n))
      pi[n], pi[s] = pi[s], pi[n]
    end
    pi
  end

  def rank(pi)  # nonrecursive version of Myrvold Ruskey rank2 algorithm.
    pi = pi.dup
    pi1 = pi.zip(0...pi.size).sort.map(&:last)
    (pi.size-1).downto(0).inject(0) do |memo,i|
      pi[i], pi[pi1[i]] = pi[pi1[i]], (s = pi[i])
      pi1[s], pi1[i] = pi1[i], pi1[s]
      memo += s * fact(i)
    end
  end

  private
  def fact(n)
    n.zero? ? 1 : n.downto(1).inject(:*)
  end
end
