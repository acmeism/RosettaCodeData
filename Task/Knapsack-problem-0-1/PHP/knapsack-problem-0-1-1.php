#########################################################
# 0-1 Knapsack Problem Solve with memoization optimize and index returns
# $w = weight of item
# $v = value of item
# $i = index
# $aW = Available Weight
# $m = Memo items array
# PHP Translation from Python, Memoization,
# and index return functionality added by Brian Berneker
#
#########################################################

function knapSolveFast2($w, $v, $i, $aW, &$m) {

	global $numcalls;
	$numcalls ++;
	// echo "Called with i=$i, aW=$aW<br>";

	// Return memo if we have one
	if (isset($m[$i][$aW])) {
		return array( $m[$i][$aW], $m['picked'][$i][$aW] );
	} else {

		// At end of decision branch
		if ($i == 0) {
			if ($w[$i] <= $aW) { // Will this item fit?
				$m[$i][$aW] = $v[$i]; // Memo this item
				$m['picked'][$i][$aW] = array($i); // and the picked item
				return array($v[$i],array($i)); // Return the value of this item and add it to the picked list

			} else {
				// Won't fit
				$m[$i][$aW] = 0; // Memo zero
				$m['picked'][$i][$aW] = array(); // and a blank array entry...
				return array(0,array()); // Return nothing
			}
		}	
	
		// Not at end of decision branch..
		// Get the result of the next branch (without this one)
		list ($without_i, $without_PI) = knapSolveFast2($w, $v, $i-1, $aW, $m);

		if ($w[$i] > $aW) { // Does it return too many?
			
			$m[$i][$aW] = $without_i; // Memo without including this one
			$m['picked'][$i][$aW] = $without_PI; // and a blank array entry...
			return array($without_i, $without_PI); // and return it

		} else {
		
			// Get the result of the next branch (WITH this one picked, so available weight is reduced)
			list ($with_i,$with_PI) = knapSolveFast2($w, $v, ($i-1), ($aW - $w[$i]), $m);
			$with_i += $v[$i];  // ..and add the value of this one..
			
			// Get the greater of WITH or WITHOUT
			if ($with_i > $without_i) {
				$res = $with_i;
				$picked = $with_PI;
				array_push($picked,$i);
			} else {
				$res = $without_i;
				$picked = $without_PI;
			}
						
			$m[$i][$aW] = $res; // Store it in the memo
			$m['picked'][$i][$aW] = $picked; // and store the picked item
			return array ($res,$picked); // and then return it
		}	
	}
}



$items4 = array("map","compass","water","sandwich","glucose","tin","banana","apple","cheese","beer","suntan cream","camera","t-shirt","trousers","umbrella","waterproof trousers","waterproof overclothes","note-case","sunglasses","towel","socks","book");
$w4 = array(9,13,153,50,15,68,27,39,23,52,11,32,24,48,73,42,43,22,7,18,4,30);
$v4 = array(150,35,200,160,60,45,60,40,30,10,70,30,15,10,40,70,75,80,20,12,50,10);

## Initialize
$numcalls = 0; $m = array(); $pickedItems = array();

## Solve
list ($m4,$pickedItems) = knapSolveFast2($w4, $v4, sizeof($v4) -1, 400, $m);

# Display Result
echo "<b>Items:</b><br>".join(", ",$items4)."<br>";
echo "<b>Max Value Found:</b><br>$m4 (in $numcalls calls)<br>";
echo "<b>Array Indices:</b><br>".join(",",$pickedItems)."<br>";


echo "<b>Chosen Items:</b><br>";
echo "<table border cellspacing=0>";
echo "<tr><td>Item</td><td>Value</td><td>Weight</td></tr>";
$totalVal = $totalWt = 0;
foreach($pickedItems as $key) {
	$totalVal += $v4[$key];
	$totalWt += $w4[$key];
	echo "<tr><td>".$items4[$key]."</td><td>".$v4[$key]."</td><td>".$w4[$key]."</td></tr>";
}
echo "<tr><td align=right><b>Totals</b></td><td>$totalVal</td><td>$totalWt</td></tr>";
echo "</table><hr>";
