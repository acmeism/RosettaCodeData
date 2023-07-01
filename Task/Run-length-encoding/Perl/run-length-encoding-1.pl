sub encode {
    shift =~ s/(.)\1*/length($&).$1/grse;
}

sub decode {
    shift =~ s/(\d+)(.)/$2 x $1/grse;
}
