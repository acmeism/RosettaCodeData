set ntokens to 12
repeat
   log "There are " & ntokens & " tokens left."
   set taker to display alert "How many tokens to take?" buttons {1, 2, 3}
   set ptake to button returned of taker
   log "You took " & ptake & " token(s)."
   set ctake to 4 - ptake
   log "The computer took " & ctake & " token(s)."
   set ntokens to ntokens - 4
   if ntokens = 0 then
      log "No tokens left. Game over!"
      exit repeat
   end if
end repeat
