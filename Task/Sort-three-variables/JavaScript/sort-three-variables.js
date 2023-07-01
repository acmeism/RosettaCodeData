const printThree = (note, [a, b, c], [a1, b1, c1]) => {
  console.log(`${note}
    ${a} is: ${a1}
    ${b} is: ${b1}
    ${c} is: ${c1}
  `);
};
const sortThree = () => {

  let a = 'lions, tigers, and';
  let b = 'bears, oh my!';
  let c = '(from the "Wizard of OZ")';
  printThree('Before Sorting', ['a', 'b', 'c'], [a, b, c]);

  [a, b, c] = [a, b, c].sort();
  printThree('After Sorting', ['a', 'b', 'c'], [a, b, c]);

  let x = 77444;
  let y = -12;
  let z = 0;
  printThree('Before Sorting', ['x', 'y', 'z'], [x, y, z]);

  [x, y, z] = [x, y, z].sort();
  printThree('After Sorting', ['x', 'y', 'z'], [x, y, z]);
};
sortThree();
