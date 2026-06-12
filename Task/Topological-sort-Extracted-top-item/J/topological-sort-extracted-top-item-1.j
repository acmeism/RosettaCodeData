compileOrder=: dyad define
  targets=. ;: x
  parsed=. <@;:;._2 y
  names=. ~.({.&>parsed),targets,;parsed
  depends=. (> =@i.@#) names e.S:1 (#names){.parsed
  depends=. (+. +./ .*.~)^:_ depends
  b=. +./depends (] , #~) names e. targets
  names (</.~ \: ~.@])&(keep&#) +/"1 depends
  (b#names) (</.~ /: ~.@]) +/ }.+./ .*.~&(b#"1 b#depends)^:a: 1
)

topLevel=:  [: ({.&> -. [:;}.&.>) <@;:;._2
