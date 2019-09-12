grammar IP_Addr {
    token TOP { ^ [ <IPv4> | <IPv6> ] $ }

    token IPv4 {
        [ <d8> +% '.' ] <?{ $<d8> == 4 }> <port>?
                { @*by8 = @$<d8> }
    }

    token IPv6 {
        |     <ipv6>
        | '[' <ipv6> ']' <port>
    }

    token ipv6 {
        | <h16> +% ':' <?{ $<h16> == 8 }>
                { @*by16 = @$<h16> }

        | [ (<h16>) +% ':']? '::' [ (<h16>) +% ':' ]? <?{ @$0 + @$1 ≤ 8 }>
                { @*by16 = |@$0, |('0' xx 8 - (@$0 + @$1)), |@$1 }

        | '::ffff:' <IPv4>
                { @*by16 = |('0' xx 5), 'ffff', |(by8to16 @*by8) }
    }

    token d8  { (\d+) <?{ $0 < 256   }> }
    token d16 { (\d+) <?{ $0 < 65536 }> }
    token h16 { (<:hexdigit>+) <?{ @$0 ≤ 4 }> }

    token port {
        ':' <d16> { $*port = +$<d16> }
    }
}

sub by8to16 (@m) { gather for @m -> $a,$b { take ($a * 256 + $b).fmt("%04x") } }

my @cases = <
    127.0.0.1
    127.0.0.1:80
    ::1
    [::1]:80
    2605:2700:0:3::4713:93e3
    [2605:2700:0:3::4713:93e3]:80
    2001:db8:85a3:0:0:8a2e:370:7334
    2001:db8:85a3::8a2e:370:7334
    [2001:db8:85a3:8d3:1319:8a2e:370:7348]:443
    192.168.0.1
    ::ffff:192.168.0.1
    ::ffff:71.19.147.227
    [::ffff:71.19.147.227]:80
    ::
    256.0.0.0
    g::1
    0000
    0000:0000
    0000:0000:0000:0000:0000:0000:0000:0000
    0000:0000:0000::0000:0000
    0000::0000::0000:0000
    ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
    ffff:ffff:ffff:fffg:ffff:ffff:ffff:ffff
    fff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
    fff:ffff:0:ffff:ffff:ffff:ffff:ffff
>;

for @cases -> $addr {
    my @*by8;
    my @*by16;
    my $*port;

    IP_Addr.parse($addr);

    say $addr;
    if @*by16 {
        say "  IPv6: ", @*by16.map({:16(~$_)})».fmt("%04x").join;
        say "  Port: ", $*port if $*port;
    }
    elsif @*by8 {
        say "  IPv4: ", @*by8».fmt("%02x").join;
        say "  Port: ", $*port if $*port;
    }
    else {
        say "  BOGUS!";
    }
    say '';
}
