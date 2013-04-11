while '' ne my $answer = prompt 'Temperature: ' {
    my $k = do given $answer {
        when s/:i C $// { $_ + 273.15 }
        when s/:i F $// { ($_ + 459.67) / 1.8 }
        when s/:i R $// { $_ / 1.8 }
        when s/:i K $// { $_ }
        default         { $_ }
    }
    say "  { $k }K";
    say "  { $k - 273.15 }℃";
    say "  { $k * 1.8 - 459.67 }℉";
    say "  { $k * 1.8 }R";
}
