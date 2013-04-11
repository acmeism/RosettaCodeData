function F = fibonacci(n)

    Fn = [1 0]; %Fn(1) is F_{n-2}, Fn(2) is F_{n-1}
    F = 0; %F is F_{n}

    for i = (1:abs(n))
        Fn(2) = F;
        F = sum(Fn);
        Fn(1) = Fn(2);
    end

    if n < 0
        F = F*((-1)^(n+1));
    end

end
