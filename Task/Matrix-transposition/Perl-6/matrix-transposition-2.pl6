sub transpose (@m) {
    @m[0].keys.map: {[ @m».[$_] ]};
}

my @a = [< a b c d e >],
        [< f g h i j >],
        [< k l m n o >],
        [< p q r s t >];

.say for @a.&transpose;
