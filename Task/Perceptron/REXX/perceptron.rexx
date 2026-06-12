/* REXX */
Call init
Call time 'R'
try=0
Call show 0
Do d=1 To dots
  x=x.d
  y=y.d
  Parse Value x y 1 with inputs.0 inputs.1 inputs.2
  answer.d=sign(y-f(x))
  Select
    When f(x)<y Then r='<'
    When f(x)>y Then r='>'
    Otherwise        r='='
    End
  training.d=x y 1 answer.d
  End
Do try=1 To tries
  Call time 'R'
  zz=0
  Do d=1 To dots
    Parse Var training.d inputs.0 inputs.1 inputs.2 answer.d
    Call train d
    Do ii=1 To d
      Parse Var training.ii inputs.0 inputs.1 inputs.2 answer.d
      guess = feedForward(d)
      End
    End
  Call show try
  End
Exit

show:
  Parse Arg run
  show=wordpos(run,'0 1' tries)>0
  If run>0 Then Say ' '
  If show Then  Say 'Point    x f(x) r    y ff ok   zz'
  zz=0
  Do d=1 To dots
    x=x.d
    y=y.d
    Parse Value x.d y.d 1 with inputs.0 inputs.1 inputs.2
    ff=format(feedForward(),2)
    Select
      When f(x)<y Then r='<'
      When f(x)>y Then r='>'
      Otherwise        r='='
      End
    If r='<' & ff=1 |,
       r='>' & ff=-1 Then Do; tag='ok'; zz=zz+1; End
                     Else tag='--'
    If show Then
     Say format(d,5) format(x,4,0) format(f(x),4,0) r format(y,4,0) right(ff,2),
                                                                    tag format(zz,4)
    End
  If show Then Say copies('-',33)
  weights=format(weights.0,2,5) format(weights.1,2,5) format(weights.2,2,5)
  Select
    When run=0 Then txt='Initial pattern'
    When run=1 Then txt='After one loop '
    Otherwise       txt='After' run 'loops'
    End
  Say left(txt,15) format(zz,4) 'points fire. weights='weights
  Return

train: Procedure Expose inputs. weights.
  desired=sign(inputs.1-f(inputs.0))
  guess  = feedForward()
  error  = desired-guess
  Do i=0 To 2
    weights.i=weights.i+0.00001*error*inputs.i
    End
  Return

f: Return arg(1)*0.7+40

nextDouble: /* random number between -1 and +1 */
  Return random(100000)/100000

feedforward: Procedure Expose inputs. weights.
  sum=0
  Do i=0 To 2
    sum=sum+inputs.i*weights.i
    End
  Return activate(sum)

activate:
  If arg(1)>0 Then Return 1
              Else Return -1

init:
  Call random 10000,10000,333 /* seed the random function */
  dots=30
  width=640
  height=360
  tries=10
  Do i=0 To 2
    weights.i=nextDouble()
    End
  Do i=1 To dots
    x.i=nextDouble()*width
    y.i=nextDouble()*height
    End
  Return
