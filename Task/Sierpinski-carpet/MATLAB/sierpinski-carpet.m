n = 3;
c = string('#');
for k = 1 : n
  c = [c + c + c, c + c.replace('#', ' ') + c, c + c + c];
end
disp(c.join(char(10)))
