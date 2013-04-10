/*REXX program that implements various   List Manager   functions.      */
/*┌────────────────────────────────────────────────────────────────────┐
┌─┘        ☼☼☼☼☼☼☼☼☼☼☼ Functions of the  List Manager ☼☼☼☼☼☼☼☼☼☼☼      └─┐
│   @init      ─── initializes the List.                                 │
│                                                                        │
│   @size      ─── returns the size of the List  [could be  0  (zero)].  │
│                                                                        │
│   @show      ─── shows (displays) the complete List.                   │
│   @show k,1  ─── shows (displays) the  Kth  item.                      │
│   @show k,m  ─── shows (displays)  M  items,  starting with  Kth  item.│
│   @show ,,─1 ─── shows (displays) the complete List backwards.         │
│                                                                        │
│   @get  k    ─── returns the  Kth  item.                               │
│   @get  k,m  ─── returns the  M  items  starting with the  Kth  item.  │
│                                                                        │
│   @put  x    ─── adds the  X  items to the  end  (tail) of the List.   │
│   @put  x,0  ─── adds the  X  items to the start (head) of the List.   │
│   @put  x,k  ─── adds the  X  items to before of the  Kth  item.       │
│                                                                        │
│   @del  k    ─── deletes the item  K.                                  │
└─┐ @del  k,m  ─── deletes the   M  items  starting with item  K.      ┌─┘
  └────────────────────────────────────────────────────────────────────┘*/
call sy 'initializing the list.'           ; call @init
call sy 'building list: Was it a cat I saw'; call @put 'Was it a cat I saw'
call sy 'displaying list size.'            ; say 'list size='@size()
call sy 'forward list'                     ; call @show
call sy 'backward list'                    ; call @show ,,-1
call sy 'showing 4th item'                 ; call @show 4,1
call sy 'showing 5th & 6th items'          ; call @show 5,2
call sy 'adding item before item 4: black' ; call @put 'black',4
call sy 'showing list'                     ; call @show
call sy 'adding to tail: there, in the ...'; call @put 'there, in the shadows, stalking its prey (and next meal).'
call sy 'showing list'                     ; call @show
call sy 'adding to head: Oy!'              ; call @put  'Oy!',0
call sy 'showing list'                     ; call @show
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────subroutines─────────────────────────*/
p:       return word(arg(1), 1)        /*pick the first word of many.   */
sy:      say;   say left('', 30) "───" arg(1) '───';           return
@init:   $.@=;    @adjust: $.@=space($.@);   $.#=words($.@);   return
@hasopt: arg o;            return pos(o, opt)\==0
@size:   return $.#

@del:    procedure expose $.;     arg k,m;          call @parms 'km'
         _=subword($.@, k, k-1)   subword($.@, k+m)
         $.@=_;                   call @adjust
         return

@get:    procedure expose $.;     arg k,m,dir,_
         call @parms 'kmd'
                                  do j=k for m  by dir  while j>0 & j<=$.#
                                  _=_ subword($.@, j, 1)
                                  end   /*j*/
         return strip(_)

@parms:  arg opt                       /*define a variable based on OPT.*/
                 if @hasopt('k')  then k=min($.#+1, max(1,p(k 1)))
                 if @hasopt('m')  then m=p(m 1)
                 if @hasopt('d')  then dir=p(dir 1)
         return

@put:    procedure expose $.;     parse arg x,k ;       k=p(k $.#+1)
         call @parms 'k'
         $.@=subword($.@, 1, max(0, k-1))   x   subword($.@, k)
         call @adjust
         return

@show:   procedure expose $.;     parse arg k,m,dir
         if dir==-1 & k==''  then k=$.#;                m=p(m $.#)
         call @parms 'kmd';       say @get(k,m, dir);   return
