bottles
 set template1="i_n_""of beer on the wall.  ""_i_n_"" of beer.  """
 set template2="""Take""_n2_""down, pass it around.  """
 set template3="j_n3_""of beer on the wall."""
 for i=99:-1:1 do  write ! hang 1
 . set:i>1 n=" bottles ",n2=" one " set:i=1 n=" bottle ",n2=" it "
 . set n3=" bottle " set j=i-1 set:(j>1)!(j=0) n3=" bottles " set:j=0 j="No"
 . write @template1,@template2,@template3

repeat
 write "One more time!",! hang 5
 goto bottles
