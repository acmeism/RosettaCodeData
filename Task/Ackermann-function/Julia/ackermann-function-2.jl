ack2(m::Integer, n::Integer) = m == 0 ? n + 1 : n == 0 ? ack2(m - 1, 1) : ack2(m - 1, ack2(m, n - 1))
