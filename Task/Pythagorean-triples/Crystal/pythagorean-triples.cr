class PythagoranTriplesCounter
  def initialize(limit = 0)
    @limit = limit
    @total = 0
    @primitives = 0
    generate_triples(3, 4, 5)
  end

  def total; @total end
  def primitives; @primitives end

  private def generate_triples(a, b, c)
    perim = a + b + c
    return if perim > @limit

    @primitives += 1
    @total += @limit // perim

    generate_triples( a-2*b+2*c, 2*a-b+2*c, 2*a-2*b+3*c )
    generate_triples( a+2*b+2*c, 2*a+b+2*c, 2*a+2*b+3*c )
    generate_triples(-a+2*b+2*c,-2*a+b+2*c,-2*a+2*b+3*c )
  end
end

perim = 10
while perim <= 100_000_000
  c = PythagoranTriplesCounter.new perim
  p [perim, c.total, c.primitives]
  perim *= 10
end
