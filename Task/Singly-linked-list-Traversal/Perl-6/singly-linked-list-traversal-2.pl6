use MONKEY_TYPING;
augment class Pair {
    method traverse () {
        gather loop (my $l = self; $l; $l.=value) {
            take $l.key;
        }
    }
}

my $list = [=>] 'Ⅰ' .. 'Ⅻ', Mu;
say ~$list.traverse;
