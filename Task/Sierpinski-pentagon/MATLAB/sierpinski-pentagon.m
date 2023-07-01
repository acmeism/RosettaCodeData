[x, x0] = deal(exp(1i*(0.5:.4:2.1)*pi));
for k = 1 : 4
  x = x(:) + x0 * (1 + sqrt(5)) * (3 + sqrt(5)) ^(k - 1) / 2 ^ k;
end
patch('Faces', reshape(1 : 5 * 5 ^ k, 5, '')', 'Vertices', [real(x(:)) imag(x(:))])
axis image off
