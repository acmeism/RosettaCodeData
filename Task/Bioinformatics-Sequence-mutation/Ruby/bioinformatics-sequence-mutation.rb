class DNA_Seq
  attr_accessor :seq

  def initialize(bases: %i[A C G T] , size: 0)
    @bases = bases
    @seq   = Array.new(size){ bases.sample }
  end

  def mutate(n = 10)
    n.times{|n| method([:s, :d, :i].sample).call}
  end

  def to_s(n = 50)
    just_size = @seq.size / n
    (0...@seq.size).step(n).map{|from|  "#{from.to_s.rjust(just_size)} " + @seq[from, n].join}.join("\n") +
    "\nTotal #{seq.size}: #{@seq.tally.sort.to_h.inspect}\n\n"
  end

  def s = @seq[rand_index]= @bases.sample
  def d = @seq.delete_at(rand_index)
  def i = @seq.insert(rand_index, @bases.sample )
  alias :swap   :s
  alias :delete :d
  alias :insert :i

  private
  def rand_index = rand( @seq.size )
end

puts test = DNA_Seq.new(size: 200)
test.mutate
puts test
test.delete
puts test
