# Testing code
set testcases [split {
    dl D insert head foo
    dl D insert end  bar
    dl D insert head hello
    dl D set [dl D head] hi
    dl D insert end  grill
    set i [dl D findfrom head bar]
    dl D set    $i BAR
    dl D insert $i and
    dl D length
    dl D asList2
    dl D delete $i
    dl D findfrom head nix
    dl D delete head
    dl D delete end
    dl D delete end
    dl D delete head
    dl D length
} \n]
foreach case $testcases {
    if {[string trim $case] ne ""} {
        puts " $case -> [eval $case] : [dl D asList]"
        if {[lsearch $argv -p] >= 0} {parray D}
    }
}
