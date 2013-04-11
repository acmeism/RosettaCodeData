function n = catalanNumbers(n)
    for i = (1:length(n))
        n(i) = (1/(n(i)+1))*nchoosek(2*n(i),n(i));
    end
end
