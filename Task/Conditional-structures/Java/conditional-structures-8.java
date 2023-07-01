int x = switch (c) {
    case 'a':
        foo();
        yield 1;
    case 'b':
        bar();
    default:
        foobar();
        yield 0;
}
