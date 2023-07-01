function bitwiseOps(a,b)

    disp(sprintf('%d and %d = %d', [a b bitand(a,b)]));
    disp(sprintf('%d or %d = %d', [a b bitor(a,b)]));
    disp(sprintf('%d xor %d = %d', [a b bitxor(a,b)]));
    disp(sprintf('%d << %d = %d', [a b bitshift(a,b)]));
    disp(sprintf('%d >> %d = %d', [a b bitshift(a,-b)]));

end
