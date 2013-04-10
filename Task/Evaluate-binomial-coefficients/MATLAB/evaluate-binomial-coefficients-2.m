function r = binomcoeff1(n,k)
    r = diag(rot90(pascal(n+1))); % vector of all binomial coefficients for order n
    r = r(k);
end;
