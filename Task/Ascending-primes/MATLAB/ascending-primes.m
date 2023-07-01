queue = 1:9;

j = 1;
while j < length(queue)
    n = queue(j);
    j = j + 1;
    a = n * 10 + mod(n, 10) + 1;
    b = n * 10 + 9;
    if a <= b
        queue = [queue, a:b];
    end
end

queue(isprime(queue))
