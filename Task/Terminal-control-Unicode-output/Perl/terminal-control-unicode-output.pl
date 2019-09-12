die "Terminal can't handle UTF-8"
    unless $ENV{LC_ALL} =~ /utf-8/i or $ENV{LC_CTYPE} =~ /utf-8/i or $ENV{LANG} =~ /utf-8/i;

print "△ \n";
