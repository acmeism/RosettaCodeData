$url ~~ s:g[ '%' (<:hexdigit> ** 2) ] = chr :16(~$0);
say $url;
