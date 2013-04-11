die "Terminal can't handle UTF-8"
    unless first(*.defined, %*ENV<LC_ALL LC_CTYPE LANG>) ~~ /:i 'utf-8'/;
say "△";
