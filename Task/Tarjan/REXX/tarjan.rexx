/* REXX - Tarjan's Algorithm                        */
/* Vertices are numbered 1 to 8 (instead of 0 to 7) */
g='[2] [3] [1] [2 3 5] [4 6] [3 7] [6] [5 7 8]'
gg=g
Do i=1 By 1 While gg>''
  Parse Var gg '[' g.i ']' gg
  name.i=i-1
  End
g.0=i-1
index.=0
lowlink.=0
stacked.=0
stack.=0
x=1
Do n=1 To g.0
  If index.n=0 Then
    If strong_connect(n)=0 Then
      Return
  End
Exit

strong_connect: Procedure Expose x g. index. lowlink. stacked. stack. name.
Parse Arg n
index.n = x
lowlink.n = x
stacked.n = 1
Call stack n
x=x+1
Do b=1 To words(g.n)
  Call show_all
  nb=word(g.n,b)
  If index.nb=0 Then Do
    If strong_connect(nb)=0 Then
      Return 0
    If lowlink.nb < lowlink.n Then
      lowlink.n = lowlink.nb
    End
  Else Do
    If stacked.nb = 1 Then
      If index.nb < lowlink.n Then
        lowlink.n = index.nb
    end
  end
if lowlink.n=index.n then Do
  c=''
  Do z=stack.0 By -1
    w=stack.z
    stacked.w=0
    stack.0=stack.0-1
    c=name.w c
    If w=n Then Do
      Say '['space(c)']'
      Return 1
      End
    End
  End
Return 1

stack: Procedure Expose stack.
Parse Arg m
z=stack.0+1
stack.z=m
stack.0=z
Return

/* The following were used for debugging (and understanding) */

show_all: Return
ind='Index  '
low='Lowlink'
sta='Stacked'
Do z=1 To g.0
  ind=ind index.z
  low=low lowlink.z
  sta=sta stacked.z
  End
Say ind
Say low
Say sta
Return

show_stack:
ol='Stack'
Do z=1 To stack.0
  ol=ol stack.z
  End
Say ol
Return
