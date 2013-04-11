function Mn = male(n)

    if n == 0
        Mn = 0;
        return
    end

    Mn = n - female(male(n-1));
end
