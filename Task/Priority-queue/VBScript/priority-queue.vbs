option explicit
 Class prio_queue
  private size
  private q

  'adapt this function to your data
  private function out_of_order(f1,f2): out_of_order = f1(0)>f2(0):end function

 function peek
    peek=q(1)
 end function

 property get qty
    qty=size
 end property

property get isempty
    isempty=(size=0)
end property

 function remove
    dim x
    x=q(1)
    q(1)=q(size)
    size=size-1
    sift_down
    remove=x
 end function

 sub add (x)
    size=size+1
    if size>ubound(q) then redim preserve q(ubound(q)*1.1)
    q(size)=x
    sift_up
 end sub

 Private sub swap (i,j)
    dim x
    x=q(i):q(i)=q(j):q(j)=x
  end sub

  private sub sift_up
    dim h,p
    h=size
    p=h\2
    if p=0 then exit sub
   while out_of_order(q(p),q(h))
       swap h,p
       h=p
       p=h\2
      if p=0 then exit sub
    wend
 end sub

  end sub

  private sub sift_down
  dim p,h
  p=1
  do
    if p>=size then exit do
    h =p*2
    if h >size then exit do
    if h+1<=size then if  out_of_order(q(h),q(h+1)) then h=h+1
    if out_of_order(q(p),q(h)) then swap h,p
    p=h
  loop
 end sub

 'Al instanciar objeto con New
 Private Sub Class_Initialize(  )
     redim q(100)
     size=0
 End Sub

'When Object is Set to Nothing
 Private Sub Class_Terminate(  )
      erase q
 End Sub
End Class
'-------------------------------------
'test program
'---------------------------------
dim tasks:tasks=array(_
  array(3,"Clear drains"),_
  array(4,"Feed cat"),_
  array(5,"Make tea"),_
  array(1,"Solve RC tasks"),_
  array(2,"Tax return"))

dim queue,i,x
set queue=new prio_queue
for i=0 to ubound(tasks)
   queue.add(tasks(i))
next

wscript.echo  "Done: " & queue.qty() &" items in queue. "&  queue.peek()(1)& " is at the top." & vbcrlf

while not queue.isempty()
   x=queue.remove()
   wscript.echo x(0),x(1)
wend

set queue= nothing
