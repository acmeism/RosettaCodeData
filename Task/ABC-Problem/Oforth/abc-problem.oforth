import: mapping

["BO","XK","DQ","CP","NA","GT","RE","TG","QD","FS","JW","HU","VI","AN","OB","ER","FS","LY","PC","ZM"]
const: ABCBlocks

: canMakeWord(w, blocks)
| i |
   w empty? ifTrue: [ true return ]
   blocks size loop: i [
      w first >upper  blocks at(i) include? ifFalse: [ continue ]
      canMakeWord( w right( w size 1- ), blocks del(i, i) ) ifTrue: [ true return ]
      ]
   false
;
