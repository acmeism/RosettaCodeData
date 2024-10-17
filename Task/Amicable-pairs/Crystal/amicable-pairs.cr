MX = 524_000_000
N = Math.sqrt(MX).to_u32
x = Array(Int32).new(MX+1, 1)

(2..N).each { |i|
    p = i*i
    x[p] += i
    k = i+i+1
    (p+i..MX).step(i) { |j|
        x[j] += k
        k += 1
    }
}

(4..MX).each { |m|
    n = x[m]
    if n < m && n != 0 && m == x[n]
        puts "#{n} #{m}"
    end
}
