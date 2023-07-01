given (0..0x1fffd).chrs {
    say "Lowercase: ", .comb(/<:Ll>/);
    say "Uppercase: ", .comb(/<:Lu>/);
    say "Titlecase: ", .comb(/<:Lt>/);
}
