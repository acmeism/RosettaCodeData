split=:1 :0
  ({. ; ] }.~ 1+[)~ i.&m
)

uriparts=:3 :0
  'server fragment'=. '#' split y
  'sa query'=. '?' split server
  'scheme authpath'=. ':' split sa
  scheme;authpath;query;fragment
)

queryparts=:3 :0
  (0<#y)#<;._1 '?',y
)

authpathparts=:3 :0
  if. '//' -: 2{.y do.
    split=. <;.1 y
    (}.1{::split);;2}.split
  else.
    '';y
  end.
)

authparts=:3 :0
  if. '@' e. y do.
    'userinfo hostport'=. '@' split y
  else.
    hostport=. y [ userinfo=.''
  end.
  if. '[' = {.hostport do.
     'host_t port_t'=. ']' split hostport
     assert. (0=#port_t)+.':'={.port_t
     (':' split userinfo),(host_t,']');}.port_t
  else.
     (':' split userinfo),':' split hostport
  end.
)

taskparts=:3 :0
  'scheme authpath querystring fragment'=. uriparts y
  'auth path'=. authpathparts authpath
  'user creds host port'=. authparts auth
  query=. queryparts querystring
  export=. ;:'scheme user creds host port path query fragment'
  (#~ 0<#@>@{:"1) (,. do each) export
)
