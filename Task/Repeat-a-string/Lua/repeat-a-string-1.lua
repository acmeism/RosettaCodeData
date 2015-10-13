function repeats(s, n) return n > 0 and s .. repeats(s, n-1) or "" end
