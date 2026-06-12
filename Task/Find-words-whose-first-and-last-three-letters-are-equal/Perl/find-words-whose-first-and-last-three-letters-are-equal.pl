// 20210212 Perl programming solution

perl -ne '/(?=^(.{3}).*\1$)^.{6,}$/&&print' unixdict.txt

# minor variation

perl -ne 's/(?=^(.{3}).*\1$)^.{6,}$/print/e' unixdict.txt
