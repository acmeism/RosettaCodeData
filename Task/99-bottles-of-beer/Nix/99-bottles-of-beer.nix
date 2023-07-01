with builtins;
let
  bottle = x: "${toString x} bottle${if (x == 1) then "" else "s"} of beer";
  beer = { x ? 99 }: if (x == 0) then "" else ''
    ${bottle x} on the wall
    ${bottle x}
    Take one down, pass it around
    ${bottle (x - 1)} on the wall

    ${beer { x = x - 1; }}'';
in
beer { }
