33> {ok, {hostent, Host, Aliases, AddrType, Bytes, AddrList}} = inet:gethostbyname("www.kame.net", inet).
{ok,{hostent,"orange.kame.net",
             ["www.kame.net"],
             inet,4,
             [{203,178,141,194}]}}
34> [inet_parse:ntoa(Addr) || Addr <- AddrList].
["203.178.141.194"]
35> f().
ok
36> {ok, {hostent, Host, Aliases, AddrType, Bytes, AddrList}} = inet:gethostbyname("www.kame.net", inet6).
{ok,{hostent,"orange.kame.net",[],inet6,16,
             [{8193,512,3583,65521,534,16127,65201,17623}]}}
37> [inet_parse:ntoa(Addr) || Addr <- AddrList].
["2001:200:DFF:FFF1:216:3EFF:FEB1:44D7"]
