set words = "A'BARK'BOOK'TREAT'COMMON'SQUAD'CONFUSE"
set result = *
loop word = words
   set blocks = "BO'XK'DQ'CP'NA'GT'RE'TG'QD'FS'JW'HU'VI'AN'OB'ER'FS'LY'PC'ZM"
   set wordx = split (word, |"~</~")
   set cond = "true"
   loop char = wordx
      set n = filter_index (blocks, "~*{char}*~", -)
      if (n.eq."") then
         set cond = "false"
         exit
      endif
      set n2 = select (n, 1)
      set n3 = select (blocks, #n2, blocks)
   endloop
   set out = concat (word, " ", cond)
   set result = append (result, out)
endloop
