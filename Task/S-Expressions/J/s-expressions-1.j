NB. character classes: 0: paren, 1: quote, 2: whitespace, 3: wordforming (default)
chrMap=: '()';'"';' ',LF,TAB,CR

NB. state columns correspond to the above character classes
NB. first digit chooses next state.
NB. second digit is action 0: do nothing, 1: start word, 2: end word
states=: 10 10#: ".;._2]0 :0
  11  21  00  31  NB. state 0: initial state
  12  22  02  32  NB. state 1: after () or after closing "
  40  10  40  40  NB. state 2: after opening "
  12  22  02  30  NB. state 3: after word forming character
  40  10  40  40  NB. state 4: between opening " and closing "
)

tokenize=: (0;states;<chrMap)&;:

rdSexpr=:3 :0 :.wrSexpr
  s=. r=. '' [ 'L R'=. ;:'()'
  for_token. tokenize y do.
    select. token
      case. L do. r=. ''  [ s=. s,<r
      case. R do. s=. }:s [ r=. (_1{::s),<r
      case.   do. r=. r,token
    end.
  end.
  >{.r
)

wrSexpr=: ('(' , ;:^:_1 , ')'"_)^:L.L:1^:L. :.rdSexpr

fmt=: 3 :0 :.unfmt
  if. '"' e. {.y     do. }.,}: y  NB. quoted string
  elseif. 0=#$n=.".y do. n        NB. number or character
  elseif.            do. s:<y     NB. symbol
  end.
)

unfmt=: 3 :0 :.fmt
  select. 3!:0 y
    case. 1;4;8;16;128 do. ":!.20 y
    case. 2;131072     do.
      select. #$y
        case. 0 do. '''',y,''''
        case. 1 do. '"',y,'"'
      end.
    case. 64           do. (":y),'x'
    case. 65536        do. >s:inv y
  end.
)

readSexpr=: fmt L:0 @rdSexpr :.writeSexpr
writeSexpr=: wrSexpr @(unfmt L:0) :.readSexpr
