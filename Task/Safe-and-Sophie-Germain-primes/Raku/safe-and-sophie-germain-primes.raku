put join "\n", (^∞ .grep: { .is-prime && ($_*2+1).is-prime } )[^50].batch(10)».fmt: "%4d";
