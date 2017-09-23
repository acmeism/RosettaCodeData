     select
     when a=='angel'              then many='host'
     when a=='ass' | a=='donkey'  then many='pace'
     when a=='crocodile'          then many='bask'
     when a=='crow'               then many='murder'
     when a=='lark'               then many='ascension'
     when a=='quail'              then many='bevy'
     when a=='wolf'               then many='pack'
     otherwise  say
                say '*** error! ***'
                say a "isn't one of the known thingys."
                say
                exit 13
     end
