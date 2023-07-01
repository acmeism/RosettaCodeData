a = false(1,100);
for b=1:100
  for i = b:b:100
    a(i) = ~a(i);
  end
end
a
