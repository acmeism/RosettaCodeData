     select
     when g=='angel'              then many='host'
     when g=='ass' | g=='donkey'  then many='pace'
     when g=='crocodile'          then many='bask'
     when g=='crow'               then many='murder'
     when g=='lark'               then many='ascension'
     when g=='quail'              then many='bevy'
     when g=='wolf'               then many='pack'
     otherwise  say
                say '*** error! ***'
                say g "isn't one of the known thingys."
                say
                exit 13
     end   /*select*/
