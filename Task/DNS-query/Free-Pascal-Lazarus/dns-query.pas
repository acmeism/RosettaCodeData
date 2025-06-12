program DNSQuery;
uses netdb,sysutils;
const
  DOMAIN_NAME = 'www.kame.net';

var
host: THostEntry;
host6: THostEntry6;
i : integer;
begin
  if ResolveHostByName(DOMAIN_NAME, host) then
  begin
    writeln('IPv4 : ',host.Addr.s_bytes[1],'.',host.Addr.s_bytes[2],'.',host.Addr.s_bytes[3],'.',host.Addr.s_bytes[4]);
  end else
  begin
    writeln(DOMAIN_NAME,' did not resolve');
    halt(0);
  end;

  if ResolveHostByName6(DOMAIN_NAME, host6) then
  begin
    i := 0;
    write('IPv6 : ');
    while i <14 do
    begin
      write(inttohex(host6.Addr.u6_addr8[i]),inttohex(host6.Addr.u6_addr8[i+1]),':');
      inc(i,2);
    end;
    writeln(inttohex(host6.Addr.u6_addr8[i]),inttohex(host6.Addr.u6_addr8[i+1]));
  end else
  begin
    writeln(DOMAIN_NAME,' did not resolve');
    halt(0);
  end;
end.
