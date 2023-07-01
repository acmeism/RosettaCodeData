int y = switch (c) {
    case '1', '2' -> 1 // multiple cases can be on one line
    default -> { // use a block for multiple statements
        foobar();
        yield 0;
    }
}
