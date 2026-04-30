begin

integer a, b;
write("First number:" );
read(a);
write("Second number: ");
read(b);

if a = b then
  write("The two numbers are equal")
else if a < b then
  write("The first number is less than the second")
else % a must be greater than b %
  write("The first number is greater than the second");

end
