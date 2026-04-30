a=array( _
array("fly",""),_
array("spider","That wiggled and jiggled and tickled inside her"), _
array("bird","How absurd, to swallow a bird"), _
array("cat","Imagine that. She swallowed a cat"), _
array("dog","What a hog to swallow a dog"), _
array("goat","She just opened her throat and swallowed that goat"),_
array("cow","I don't know how she swallowed that cow"), _
array("horse","She's dead of course...")_
)

b1="I don't know why she swallowed the fly." & vbcrlf &"Perhaps she'll die."& vbcrlf
b2="There was an old lady who swallowed a @ani@."
b3="She swallowed the @ani@ to catch the @pani@."

sub print(s): wscript.stdout.write(s) & vbcrlf : end sub

for i=0 to ubound(a)
     ani=a(i)(0)
     print replace(b2,"@ani@",ani)
     print a(i)(1)
     if i=ubound(a) then exit for  'horse
   for j= i-1 to 0 step -1
      oldani=ani
      ani=a(j)(0)
      print replace(replace(b3,"@ani@",oldani),"@pani@",ani)
      if j=1 then print a(1)(1) ' spider
   next
   print b1
next
