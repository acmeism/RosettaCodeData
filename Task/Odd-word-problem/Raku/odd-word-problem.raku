my &in = { $*IN.getc // last }

loop {
    ew(in);
    ow(in).print;
}

multi ew ($_ where /\w/) { .print; ew(in); }
multi ew ($_)            { .print; next when "\n"; }

multi ow ($_ where /\w/) { ow(in) x .print; }
multi ow ($_)            { $_; }
