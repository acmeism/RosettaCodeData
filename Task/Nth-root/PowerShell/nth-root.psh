#NoTeS: This sample code does not validate inputs
#	Thus, if there are errors the 'scary' red-text
#	error messages will appear.
#
#	This code will not work properly in floating point values of n,
#	and negative values of A.
#
#	Supports negative values of n by reciprocating the root.

$epsilon=1E-10		#Sample Epsilon (Precision)

function power($x,$e){	#As I said in the comment
	$ret=1
	for($i=1;$i -le $e;$i++){
		$ret*=$x
	}
	return $ret
}
function root($y,$n){					#The main Function
	if (0+$n -lt 0){$tmp=-$n} else {$tmp=$n}	#This checks if n is negative.
	$ans=1

	do{
		$d = ($y/(power $ans ($tmp-1)) - $ans)/$tmp
		$ans+=$d
	} while ($d -lt -$epsilon -or $d -gt $epsilon)

	if (0+$n -lt 0){return 1/$ans} else {return $ans}
}

#Sample Inputs
root 625 2
root 2401 4
root 2 -2
root 1.23456789E-20 34
root 9.87654321E20 10	#Quite slow here, I admit...

((root 5 2)+1)/2	#Extra: Computes the golden ratio
((root 5 2)-1)/2
