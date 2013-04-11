function m(n) return n > 0 and n - f(m(n-1)) or 0 end
function f(n) return n > 0 and n - m(f(n-1)) or 1 end
