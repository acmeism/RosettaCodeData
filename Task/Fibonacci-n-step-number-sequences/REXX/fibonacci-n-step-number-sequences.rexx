/*REXX program calculates and displays   N-step  Fibonacci   sequences. */
parse arg FibName values               /*allow user to specify which Fib*/

if FibName\='' then do                 /*if specified, show that Fib.   */
                    call  nStepFib  FibName, values
                    exit               /*stick a fork in it, we're done.*/
                    end
                                       /*nothing given, so show a bunch.*/
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
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────NSTEPFIB subroutine─────────────────*/
nStepFib:  procedure;  parse arg Fname,vals,m;   if m=='' then m=30;    L=
N=words(vals)
                            do pop=1  for N       /*use  N  initial vals*/
                            @.pop=word(vals,pop)  /*populate initial #s.*/
                            end   /*pop*/
        do j=1  for m                  /*calculate  M  Fibonacci numbers*/
        if j>N then do;  @.j=0                      /*inialize the sum. */
                                do k=j-N  for N     /*sum the last N #.s*/
                                @.j=@.j+@.k         /*add the [N-j]th #.*/
                                end   /*k*/
                    end
        L=L  @.j                       /*append this Fib num to the list*/
        end   /*j*/

say right(Fname,11)'[sum'right(N,3) "terms]:" strip(L) '...'   /*show #s*/
return
