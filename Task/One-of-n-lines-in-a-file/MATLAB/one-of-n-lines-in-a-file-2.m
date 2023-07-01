x=zeros(1,10);
for k = 1:1e6;
  n = one_of_n_lines_in_a_file('f1');
  x(n) = x(n) + 1;
end;
[1:10;x]
