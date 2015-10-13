/*REXX program  calculates and displays a   N-step   Fibonacci   sequence(s). */
parse arg FibName values               /*allows a Fibonacci name, starter vals*/
if FibName\=''  then do;  call nStepFib  FibName,values;    signal done;    end
                                       /* [↓]  no args specified, show a bunch*/
call  nStepFib  'Lucas'       ,   2 1
call  nStepFib  'fibonacci'   ,   1 1
call  nStepFib  'tribonacci'  ,   1 1 2
call  nStepFib  'tetranacci'  ,   1 1 2 4
call  nStepFib  'pentanacci'  ,   1 1 2 4 8
call  nStepFib  'hexanacci'   ,   1 1 2 4 8 16
call  nStepFib  'heptanacci'  ,   1 1 2 4 8 16 32
call  nStepFib  'octonacci'   ,   1 1 2 4 8 16 32 64
call  nStepFib  'nonanacci'   ,   1 1 2 4 8 16 32 64 128
call  nStepFib  'decanacci'   ,   1 1 2 4 8 16 32 64 128 256
call  nStepFib  'undecanacci' ,   1 1 2 4 8 16 32 64 128 256 512
call  nStepFib  'dodecanacci' ,   1 1 2 4 8 16 32 64 128 256 512 1024
call  nStepFib  '13th-order'  ,   1 1 2 4 8 16 32 64 128 256 512 1024 2048
done:  exit                            /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
nStepFib:  procedure;  parse arg Fname,vals,m;    if m==''  then m=30;      L=
N=words(vals)
                             do pop=1  for N        /*use  N  initial values. */
                             @.pop=word(vals,pop)   /*populate initial numbers*/
                             end   /*pop*/
        do j=1  for m                               /*calculate M Fib numbers.*/
        if j>N  then do;  @.j=0                     /*initialize the sum to 0.*/
                                 do k=j-N  for N    /*sum the last  N numbers.*/
                                 @.j=@.j+@.k        /*add the  [N-j]th number.*/
                                 end   /*k*/
                     end
        L=L  @.j                                    /*append Fib number──►list*/
        end   /*j*/

say right(Fname,11)'[sum'right(N,3)    "terms]:"     strip(L)    '···'
return
