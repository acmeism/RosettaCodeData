var i, output;
for (i = 1; i < 101; i++) {
  output = '';
  if (!(i % 3)) output += 'Fizz';
  if (!(i % 5)) output += 'Buzz';
  console.log(output || i);
}
