n = 4;
d = string('*');
for k = 0 : n - 1
  sp = repelem(' ', 2 ^ k);
  d = [sp + d + sp, d + ' ' + d];
end
disp(d.join(char(10)))
