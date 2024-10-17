def factorial(x : Int)
    ans = 1
    (1..x).each do |i|
        ans *= i
    end
    return ans
end
