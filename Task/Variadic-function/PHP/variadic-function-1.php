function printAll() {
  foreach (func_get_args() as $x) // first way
    echo "$x\n";

  $numargs = func_num_args(); // second way
  for ($i = 0; $i < $numargs; $i++)
    echo func_get_arg($i), "\n";
}
printAll(4, 3, 5, 6, 4, 3);
printAll(4, 3, 5);
printAll("Rosetta", "Code", "Is", "Awseome!");
