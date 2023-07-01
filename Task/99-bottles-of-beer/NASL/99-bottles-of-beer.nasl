bottles = 99;
repeat {
  display(bottles, ' bottles of beer on the wall\n');
  display(bottles, ' bottles of beer\n');
  display('Take one down, pass it around\n');
  display(--bottles, ' bottles of beer on the wall\n\n');
} until bottles < 1;
