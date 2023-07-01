sub infix:<×>(@A, @B) {
  cross(@A, ([Z] @B), with => { [+] @^a Z* @^b })
  .rotor(@B);
}
