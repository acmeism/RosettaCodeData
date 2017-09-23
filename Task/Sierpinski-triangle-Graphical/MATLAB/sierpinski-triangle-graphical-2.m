t = 0 : 2^16 - 1;
plot(t, bitand(t, bitshift(t, -8)), 'k.')
