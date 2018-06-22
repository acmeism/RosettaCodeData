using Memoize
@memoize ack3(m::Integer, n::Integer) = m == 0 ? n + 1 : n == 0 ? ack3(m - 1, 1) : ack3(m - 1, ack3(m, n - 1))
