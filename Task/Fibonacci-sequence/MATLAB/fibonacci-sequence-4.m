function number = fibonacci(n)
%construct the Tartaglia/Pascal Triangle
    pt=tril(ones(n));
    for r = 3 : n
    % Every element is the addition of the two elements
    % on top of it. That means the previous row.
        for c = 2 : r-1
            pt(r, c) = pt(r-1, c-1) + pt(r-1, c);
        end
    end
    number=trace(rot90(pt));
end
