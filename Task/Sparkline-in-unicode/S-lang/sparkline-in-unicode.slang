% Just to demonstrate alternate ways of defining unicode:
private variable spchrs = "\u{2581}\u{2582}\u{2583}\u{2584}\u{2585}\u{2586}\u{2587}\u{2588}";
private variable spchrs_alt = "▁▂▃▄▅▆▇█";

define sparkline(arrstr)
{
    variable a = strtok(arrstr, " \t,"), alen = length(a), out = "";
    a = atof(a);
    variable amin = min(a), amax = max(a), span = amax - amin, i, d;

    _for i (0, alen-1, 1)
        if (span != 0) {
            % int() truncates; adding .5 here to round:
            d = int((a[i] - amin) * 7.0 / span + 0.5);
            out += substr(spchrs, d+1, 1);
        }
        else
            out += substr(spchrs, 4, 1);

    print(out);
}

if (not _slang_utf8_ok) error("Sorry, UTF8 mode is not on.");
sparkline("1 2 3 4 5 6 7 8 7 6 5 4 3 2 1");
sparkline("1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5 ");
