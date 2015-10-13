sub encode {
    shift =~ s/(.)\1{0,254}/pack("C", length($&)).$1/grse;
}

sub decode {
    shift =~ s/(.)(.)/$2 x unpack("C", $1)/grse;
}
