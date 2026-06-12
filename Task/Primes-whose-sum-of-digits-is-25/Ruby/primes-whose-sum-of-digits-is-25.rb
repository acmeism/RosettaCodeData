require 'prime'

def digitSum(n)
    sum = 0
    while n > 0
        sum += n % 10
        n /= 10
    end
    return sum
end

for p in Prime.take_while { |p| p < 5000 }
    if digitSum(p) == 25 then
        print p, "  "
    end
end
