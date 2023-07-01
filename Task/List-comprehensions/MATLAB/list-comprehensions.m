N = 20
[a,b] = meshgrid(1:N, 1:N);
c = sqrt(a.^2 + b.^2);
[x,y] = find(c == fix(c));
disp([x, y, sqrt(x.^2 + y.^2)])
