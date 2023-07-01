function Fn = female(n)

    if n == 0
        Fn = 1;
        return
    end

    Fn = n - male(female(n-1));
end
