N = 2e4
X = [(1:N)' zeros(N,1)]

X(find(members(X(:,1), primes(N)) == 1), :)  = []

for i = 1:size(X,1)
    x = X(i,1)
    p = 1:sqrt(x)
    q = x./p
    p = unique([p(find(q == round(q)))' q(find(q == round(q)))'])
    X(i,2) = sum(p(p<x))
end

X(find(sum(X,2) == 2*X(:,1)), :) = [] // delete perfect numbers

for i = 1:size(X,1)
    for j = find(X(:,2) == X(i,1))
        if X(i,2) == X(j,1) then
            amicables($+1,:) = X(i,:)
        end
    end
end

amicables = unique(gsort(amicables, 'c', 'i'), 'r')
