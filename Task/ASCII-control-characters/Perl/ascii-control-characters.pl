use charnames ":loose";
# There is no EM, use END OF MEDIUM.
# Do not confuse BEL with BELL. Starting in Perl 5.18, BELL refers to unicode emoji 0x1F514. ALERT is an alias for BEL.
# compile time literal
"\N{nul}\N{soh}\N{stx}\N{etx}\N{eot}\N{enq}\N{ack}\N{bel}\N{bs}\N{ht}\N{lf}\N{vt}\N{ff}\N{cr}\N{so}\N{si}\N{dle}\N{dc1}\N{dc2}\N{dc3}\N{dc4}\N{nak}\N{syn}\N{etb}\N{can}\N{end of medium}\N{sub}\N{esc}\N{fs}\N{gs}\N{rs}\N{us}\N{space}\N{delete}"
# run time
charnames::string_vianame $_;
