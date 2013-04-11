/*REXX program demonstrates  (see the penultimate statment)  how to     */
/*     to find the  size  (length)  of the value of a REXX variable.    */

/*REXX doesn't reserve any storage for any variables, as all variables  */
/*are stored as character strings, including boolean.   Storage is      */
/*obtained as necessary when REXX variables are assigned (or reassigned)*/

a = 456                                /*length of  A   is    3         */
b = "heptathlon"                       /*length of  B   is   10         */
c = "heptathlon (7 events)"            /*length of  C   is   21         */
d = ''                                 /*length of  D   is    0         */
d = ""                                 /*same as above.                 */
d = left('space junk' ,0)              /*same as above.                 */
d =                                    /*same as above.                 */
e = 99-9                               /*length of  E   is    2  (e=90) */
f = copies(a,100)                      /*length of  F   is  300  (a=456)*/
g.1 = -1                               /*length of  G.1 is    2         */
g.2 = -1.0000                          /*length of  G.2 is    7         */
                                       /*length of  HHH is    3         */

                                       /*Note that when a REXX variable */
                                       /*isn't SET, then the value of it*/
                                       /*is the uppercased name itself, */
                                       /*so in this case (upper):   HHH */

something = copies(a, random(100))     /*length is something, all right,*/
                                       /*could be 3 to 300 bytes, by gum*/
thingLen  = length(something)          /*use LENGTH bif to find its len.*/
say 'length of SOMETHING =' thingLen   /*display the length of SOMETHING*/

/*┌────────────────────────────────────────────────────────────────────┐
  │ Note that the variable's data (value) isn't the true cost of the   │
  │ size of the variable's value.  REXX also keeps the   name   of     │
  │ the (fully qualified) variable as well.                            │
  │                                                                    │
  │ Most REXX interpreters keep (at a miminum):                        │
  │                                                                    │
  │   ∙  a four-byte field which contains the length of the value      │
  │   ∙  a four-byte field which contains the length of the var name   │
  │   ∙  an   N-byte field which contains the name of the variable     │
  │   ∙  an   X-byte field which contains the variable's value         │
  │   ∙  a  one-byte field which contains the status of the variable   │
  │                                                                    │
  │ [Note that PC/REXX uses a two-byte field for the first two fields] │
  │                                                                    │
  │                                                                    │
  │ Consider the following two DO loops assigning a million variables: │
  │                                                                    │
  │                            do j=1 to 1000000                       │
  │                            integer_numbers.j=j                     │
  │                            end                                     │
  │                        ════════ and ════════                       │
  │                            do k=1 to 1000000                       │
  │                            #.k=k                                   │
  │                            end                                     │
  │                                                                    │
  │ The  "j" loop uses  35,777,792  bytes for the compound variables,  │
  │ The  "k" loop uses  21,777,792  bytes for the compound variables,  │
  │ (excluding the DO loop indices  [j and k]  themselves).            │
  └────────────────────────────────────────────────────────────────────┘*/
