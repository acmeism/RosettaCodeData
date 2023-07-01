sub foo {
   .say for @_;
   say .key, ': ', .value for %_;
}

foo 1, 2, command => 'buckle my shoe',
    3, 4, order => 'knock at the door';
