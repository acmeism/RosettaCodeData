let beer = 99;
while (beer > 0) {
  let verse = `${beer} bottles of beer on the wall,
  ${beer} bottles of beer!
  Take one down, pass it around
  ${beer-1} bottles of beer on the wall`;

  console.log(verse);
  beer--;
}
