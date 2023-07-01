#!/usr/bin/env raku
use v6;
react whenever Supply.from-list(@*ARGS).start({ .&sleep // +$_ }).flat { .say }
