#########################################################
# 0-1 Knapsack Problem Solve
# $w = weight of item
# $v = value of item
# $i = index
# $aW = Available Weight
# PHP Translation by Brian Berneker
#########################################################

function knapSolve($w,$v,$i,$aW) {

	global $numcalls;
	$numcalls ++;
	// echo "Called with i=$i, aW=$aW<br>";

	if ($i == 0) {
		if ($w[$i] <= $aW) {
			return $v[$i];
		} else {
			return 0;
		}
	}	
	
	$without_i = knapSolve($w, $v, $i-1, $aW);
	if ($w[$i] > $aW) {
		return $without_i;
	} else {
		$with_i = $v[$i] + knapSolve($w, $v, ($i-1), ($aW - $w[$i]));
		return max($with_i, $without_i);
	}	

}


#########################################################
# 0-1 Knapsack Problem Solve (with "memo"-ization optimization)
# $w = weight of item
# $v = value of item
# $i = index
# $aW = Available Weight
# $m = 'memo' array
# PHP Translation by Brian Berneker
#########################################################

function knapSolveFast($w,$v,$i,$aW,&$m) { // Note: We use &$m because the function writes to the $m array

	global $numcalls;
	$numcalls ++;
	// echo "Called with i=$i, aW=$aW<br>";

	// Return memo if we have one
	if (isset($m[$i][$aW])) {
		return $m[$i][$aW];
	} else {

		if ($i == 0) {
			if ($w[$i] <= $aW) {
				$m[$i][$aW] = $v[$i]; // save memo
				return $v[$i];
			} else {
				$m[$i][$aW] = 0; // save memo
				return 0;
			}
		}	
	
		$without_i = knapSolveFast($w, $v, $i-1, $aW,$m);
		if ($w[$i] > $aW) {
			$m[$i][$aW] = $without_i; // save memo
			return $without_i;
		} else {
			$with_i = $v[$i] + knapSolveFast($w, $v, ($i-1), ($aW - $w[$i]),$m);
			$res = max($with_i, $without_i);
			$m[$i][$aW] = $res; // save memo
			return $res;
		}	
	}
}


$w3 = array(1, 1, 1, 2, 2, 2, 4, 4, 4, 44, 96, 96, 96);
$v3 = array(1, 1, 1, 2, 2, 2, 4, 4, 4, 44, 96, 96, 96);

$numcalls = 0;
$m = array();
$m3 = knapSolveFast($w3, $v3, sizeof($v3) -1, 54,$m);
print_r($w3); echo "<br>FAST: ";
echo "<b>Max: $m3</b> ($numcalls calls)<br><br>";


$numcalls = 0;
$m = array();
$m3 = knapSolve($w3, $v3, sizeof($v3) -1, 54 );
print_r($w3); echo "<br>";
echo "<b>Max: $m3</b> ($numcalls calls)<br><br>";
