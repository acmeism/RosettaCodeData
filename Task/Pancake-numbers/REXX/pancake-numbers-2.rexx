/* REXX Driver for pancake.test */
do n=2 To 10
  Call pancake n
  End
pancake: Procedure
/**********************************************************************
* REXX pancake.rex
* The task is to determine p(n) for n = 1 to 9,
* and for each show an example requiring p(n) flips.
* inspired by java and output like Phix
* 20230531 Walter Pachl
**********************************************************************/
Call time 'R'
parse arg n                          -- Number of pancakes
init=left('123456789abc',n)          -- ordered pancakes
Call o 'heureka' n
q.=0                                 -- implements the queue
qp=1
ex=0
call qadd init
stackFlips.=-1                       -- initialize map
stackFlips.init=0                    -- stackFlips.v: number of flips
                                     -- from init to v
cnt.=0
cnt.1=1
max=0
Do while qp<=q.0                     -- as long we can flip
  s=qget()                           -- get head of queue
  flips=stackFlips.s+1               -- flips for the successors
  cnt.flips=cnt.flips+1              -- count them
  If flips>max Then ex=0             -- a new maximum
  max=max(max,flips)
  Do i=2 To n                        -- process n-1 successors
    t=flip(s,i)                      -- one of them
    If stackFlips.t=-1 Then Do       -- not set so far
      stackFlips.t=flips             -- flips from init to t
      Call qadd t                    -- append it to the queue
      If ex<3 Then Do                -- show the first 3 examples
        call o flips t
        If ex>=0 Then Do             -- record the data to be shown
          example=''                 -- as an example (see o2)
          Do While t<>''
            Parse Var t c +1 t
            Select
              When c='a' Then c=10
              When c='b' Then c=11
              When c='c' Then c=12
              Otherwise Nop
              End
            example=example||c||','
            End
          exf=flips
          example=strip(example,'T',',')
          End
        ex=ex+1
        End
      End
    End
  End
Call o 'max cnt.max:' max cnt.max
te=time('E')                         -- elapsed time
te=strip(format(te,8,1))
Call o te 'seconds'
Call o ''
Call o2 'p('n') = 'exf', example: {'example'} (of' cnt.max', 'te's)'
Return

flip: Procedure
Parse Arg s,k                        -- cf. flipStack in java
Return substr(s,k,1)reverse(left(s,k-1))||substr(s,k+1)

qadd:                                -- add an element to the queue
Parse Arg e
z=q.0+1
q.z=e
q.0=z
Return

qget:                                -- get top element from the queue
e=q.qp                               -- and remove it from the queue
qp=qp+1
Return e

o: -- investigation and debug output
Return
Say arg(1)
Return lineout('heureka.txt',arg(1))

o2: -- result to be shown in rosettacode
Say arg(1)
Call lineout 'heureka.out',arg(1)
Call lineout 'heureka.out'
Return
