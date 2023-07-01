/* NetRexx */
options replace format comments java crossref symbols nobinary

ir = InetAddress
addresses = InetAddress[] InetAddress.getAllByName('www.kame.net')
loop ir over addresses
  if ir <= Inet4Address then do
    say 'IPv4 :' ir.getHostAddress
    end
  if ir <= Inet6Address then do
    say 'IPv6 :' ir.getHostAddress
    end
  end ir
