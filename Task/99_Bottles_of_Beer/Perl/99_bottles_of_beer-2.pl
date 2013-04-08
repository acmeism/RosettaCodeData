for $n (reverse(0..99))
{
    $bottles = sprintf("%s bottle%s of beer on the wall\n",(($n==0)?"No":$n), (($n==1)?"":"s"));
    print( (($n==99)?"":"$bottles\n") .
	   (($n==0)?"":(substr(${bottles}x2,0,-12) . "\nTake one down, pass it around\n")) );
}
