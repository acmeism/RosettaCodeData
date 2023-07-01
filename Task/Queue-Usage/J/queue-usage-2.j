   is_empty make_empty _
1
   first_named_state =: push 9 onto make_empty _
   newer_state =: push 8 onto first_named_state
   this_state =: push 7 onto newer_state
   is_empty this_state
0
   tell_queue this_state
9 8 7
   tell_atom pop this_state
9
   tell_atom pop pop this_state
8
   tell_atom pop pop pop this_state
7
   is_empty pop pop pop this_state
1
