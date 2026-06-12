sub abbr ($_) { (.chars < 41 ?? $_ !! .substr(0,20) ~ '..' ~ .substr(*-20)) ~ " (digits: {.chars})" }

say (++$).fmt('%2d') ~ ': ' ~ .flip.&abbr for (lazy (1,1,*+*…*).hyper.grep: {.flip.is-prime})[^25];
