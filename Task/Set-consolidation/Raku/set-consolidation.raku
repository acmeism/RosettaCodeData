multi consolidate() { () }
multi consolidate(Set \this is copy, *@those) {
    gather {
        for consolidate |@those -> \that {
            if this ∩ that { this = this ∪ that }
            else           { take that }
        }
        take this;
    }
}

enum Elems <A B C D E F G H I J K>;
say $_, "\n    ==> ", consolidate |$_
    for [set(A,B), set(C,D)],
        [set(A,B), set(B,D)],
        [set(A,B), set(C,D), set(D,B)],
        [set(H,I,K), set(A,B), set(C,D), set(D,B), set(F,G,H)];
