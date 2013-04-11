#!/usr/bin/awk -f
function trim(str) {
    sub(/^[ \t]+/,"",str);  # remove leading whitespaces
    sub(/[ \t]+$/,"",str);  # remove trailing whitespaces
    return str;
}
{
    print trim($0);
}
