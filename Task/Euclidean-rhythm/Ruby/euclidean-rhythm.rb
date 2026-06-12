def e(k, n)
    s = (0...n).map { |i| i < k ? [1] : [0] }

    d = n - k
    n = [k, d].max
    k = [k, d].min
    z = d

    while z > 0 or k > 1
        k.times do |i|
            s[i].concat(s[-1 - i])
        end
        s = s[0...-k]
        z -= k
        d = n - k
        n = [k, d].max
        k = [k, d].min
    end

    s.flatten.join
end

puts e(5, 13)
# Should output: 1001010010100
