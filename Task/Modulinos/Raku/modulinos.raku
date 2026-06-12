class LUE {
    has $.answer = 42;
}

multi MAIN ('test') {
    say "ok" if LUE.new.answer == 42;
}

multi MAIN ('methods') {
    say ~LUE.^methods;
}
