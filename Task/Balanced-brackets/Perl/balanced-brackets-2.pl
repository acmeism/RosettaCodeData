sub balanced {
    shift =~ /^ ( [^\[\]]++ | \[ (?1)* \] )* $/x;
}
