def sameDigits(n,b)
    f = n % b
    while (n /= b) > 0 do
        if n % b != f then
            return false
        end
    end
    return true
end

def isBrazilian(n)
    if n < 7 then
        return false
    end
    if n % 2 == 0 then
        return true
    end
    for b in 2 .. n - 2 do
        if sameDigits(n, b) then
            return true
        end
    end
    return false
end

def isPrime(n)
    if n < 2 then
        return false
    end
    if n % 2 == 0 then
        return n == 2
    end
    if n % 3 == 0 then
        return n == 3
    end
    d = 5
    while d * d <= n do
        if n % d == 0 then
            return false
        end
        d = d + 2

        if n % d == 0 then
            return false
        end
        d = d + 4
    end
    return true
end

def main
    for kind in ["", "odd ", "prime "] do
        quiet = false
        bigLim = 99999
        limit = 20
        puts "First %d %sBrazilian numbers:" % [limit, kind]
        c = 0
        n = 7
        while c < bigLim do
            if isBrazilian(n) then
                if not quiet then
                    print "%d " % [n]
                end
                c = c + 1
                if c == limit then
                    puts
                    puts
                    quiet = true
                end
            end
            if quiet and kind != "" then
                next
            end
            if kind == "" then
                n = n + 1
            elsif kind == "odd " then
                n = n + 2
            elsif kind == "prime " then
                loop do
                    n = n + 2
                    if isPrime(n) then
                        break
                    end
                end
            else
                raise "Unexpected"
            end
        end
        if kind == "" then
            puts "The %dth Brazillian number is: %d" % [bigLim + 1, n]
            puts
        end
    end
end

main()
