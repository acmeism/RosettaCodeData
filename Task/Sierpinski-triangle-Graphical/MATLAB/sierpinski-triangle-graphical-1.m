[x, x0] = deal(cat(3, [1 0]', [-1 0]', [0 sqrt(3)]'));
for k = 1 : 6
  x = x(:,:) + x0 * 2 ^ k / 2;
end
patch('Faces', reshape(1 : 3 * 3 ^ k, 3, '')', 'Vertices', x(:,:)')
