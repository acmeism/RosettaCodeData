require 'regex strings'

normalize=:3 :0
  seen=. a:
  eol=. {:;y
  t=. ''
  for_line.<;._2;y do. lin=. deb line=.>line
    if. '#'={.line do. t=.t,line,eol
    elseif. ''-:lin do. t =. t,eol
    elseif. do.
      line=. 1 u:([-.-.)&(32+i.95)&.(3&u:) line
      base=. ('^ *;;* *';'') rxrplc line
      nm=. ;name=. {.;:toupper base
      if. -. name e. seen do.
        seen=. seen, name
        t=. t,eol,~dtb ('; '#~';'={.lin),(('^(?i) *',nm,'\b *');(nm,' ')) rxrplc base
      end.
    end.
  end.t
)

enable=:1 :0
  (<m) 1!:2~ normalize (,y,{:);<@rxrplc~&(y;~'^; *(?i)',y,'\b');.2]1!:1<m
)

disable=:1 :0
  (<m) 1!:2~ normalize (,'; ',y,{:);<@rxrplc~&(('; ',y);~'^ *(?i)',y,'\b');.2]1!:1<m
)

set=:1 :0
:
  t=. 1!:1<m
  pat=. '^ *(?i)',y,'\b.*'
  upd=. y,' ',":x
  (<m) 1!:2~ normalize (,upd,{:);<@rxrplc~&(pat;upd) t
)
