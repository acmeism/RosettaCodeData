sub extension {
    my $path = shift;
    $path =~ / \. [a-z0-9]+ $ /xi;
    $& // '';
}
