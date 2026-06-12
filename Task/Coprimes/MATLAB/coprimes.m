disp(coprime([21, 17, 36, 18, 60], [15, 23, 12, 29, 15]));

function coprimes = coprime(a,b)
gcds = gcd(a,b) == 1;
coprimes(1,:) = a(gcds);
coprimes(2,:) = b(gcds);
end
