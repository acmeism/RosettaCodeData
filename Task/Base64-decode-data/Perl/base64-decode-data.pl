sub decode_base64 {
    my($d) = @_;
    $d =~ tr!A-Za-z0-9+/!!cd;
    $d =~ s/=+$//;
    $d =~ tr!A-Za-z0-9+/! -_!;
    my $r = '';
    while( $d =~ /(.{1,60})/gs ){
        my $len = chr(32 + length($1)*3/4);
        $r .= unpack("u", $len . $1 );
    }
    $r;
}

$data = <<EOD;
J1R3YXMgYnJpbGxpZywgYW5kIHRoZSBzbGl0aHkgdG92ZXMKRGlkIGd5cmUgYW5kIGdpbWJsZSBp
biB0aGUgd2FiZToKQWxsIG1pbXN5IHdlcmUgdGhlIGJvcm9nb3ZlcywKQW5kIHRoZSBtb21lIHJh
dGhzIG91dGdyYWJlLgo=
EOD

print decode_base64($data) . "\n";
