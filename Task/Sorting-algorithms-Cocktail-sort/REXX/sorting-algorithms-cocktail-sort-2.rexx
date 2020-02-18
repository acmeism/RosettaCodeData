/*──────────────────────────────────────────────────────────────────────────────────────*/
cocktailSort2: procedure expose @.;   parse arg N   /*N:  is the number of items in @.  */
                      do until done;    done= 1     /*array items may not contain blanks*/
                         do j=1  for N-1;   jp= j+1
                         if @.j>@.jp  then parse value  0  @.j @.jp  with  done  @.jp  @.j
                         end   /*j*/
                      if done  then leave           /*No swaps done?  Then we're done.  */
                         do k=N-1  for N-1  by -1;   kp= k+1
                         if @.k>@.kp  then parse value  0  @.k @.kp  with  done  @.kp  @.k
                         end   /*k*/
                      end      /*until*/
               return
