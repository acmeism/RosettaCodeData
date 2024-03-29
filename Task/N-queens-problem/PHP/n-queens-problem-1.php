<html>
<head>
<title>
n x n Queen solving program
</title>
</head>
<body>
<?php
echo "<h1>n x n Queen solving program</h1>";

//Get the size of the board
$boardX = $_POST['boardX'];
$boardY = $_POST['boardX'];

// Function to rotate a board 90 degrees
function rotateBoard($p, $boardX) {
    $a=0;
    while ($a < count($p)) {
        $b = strlen(decbin($p[$a]))-1;
        $tmp[$b] = 1 << ($boardX - $a - 1);
        ++$a;
    }
    ksort($tmp);
    return $tmp;
}

// This function will find rotations of a solution
function findRotation($p, $boardX,$solutions){
    $tmp = rotateBoard($p,$boardX);
    // Rotated 90
    if (in_array($tmp,$solutions)) {}
    else {$solutions[] = $tmp;}

    $tmp = rotateBoard($tmp,$boardX);
    // Rotated 180
    if (in_array($tmp,$solutions)){}
    else {$solutions[] = $tmp;}

    $tmp = rotateBoard($tmp,$boardX);
    // Rotated 270
    if (in_array($tmp,$solutions)){}
    else {$solutions[] = $tmp;}

    // Reflected
    $tmp = array_reverse($p);
    if (in_array($tmp,$solutions)){}
    else {$solutions[] = $tmp;}

    $tmp = rotateBoard($tmp,$boardX);
    // Reflected and Rotated 90
    if (in_array($tmp,$solutions)){}
    else {$solutions[] = $tmp;}

    $tmp = rotateBoard($tmp,$boardX);
    // Reflected and Rotated 180
    if (in_array($tmp,$solutions)){}
    else {$solutions[] = $tmp;}

    $tmp = rotateBoard($tmp,$boardX);
    // Reflected and Rotated 270
    if (in_array($tmp,$solutions)){}
    else {$solutions[] = $tmp;}
    return $solutions;
}

// This is a function which will render the board
function renderBoard($p,$boardX) {
$img = 'data:image/png;base64,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';
echo "<table border=1 cellspacing=0 style='text-align:center;display:inline'>";
for ($y = 0; $y < $boardX; ++$y) {
	echo '<tr>';
	for ($x = 0; $x < $boardX; ++$x){
	if (($x+$y) & 1) { $cellCol = '#9C661F';}
	else {$cellCol = '#FCE6C9';}

	if ($p[$y] == 1 << $x) { echo "<td bgcolor=".$cellCol."><img width=30 height=30 src='".$img."'></td>";}
	else { echo "<td bgcolor=".$cellCol."> </td>";}
	}
	echo '<tr>';
}
echo '<tr></tr></table>&nbsp';

}

//This function allows me to generate the next order of rows.
function pc_next_permutation($p) {
    $size = count($p) - 1;
    // slide down the array looking for where we're smaller than the next guy

    for ($i = $size - 1; $p[$i] >= $p[$i+1]; --$i) { }

    // if this doesn't occur, we've finished our permutations
    // the array is reversed: (1, 2, 3, 4) => (4, 3, 2, 1)
    if ($i == -1) { return false; }

    // slide down the array looking for a bigger number than what we found before
    for ($j = $size; $p[$j] <= $p[$i]; --$j) { }
    // swap them
    $tmp = $p[$i]; $p[$i] = $p[$j]; $p[$j] = $tmp;
    // now reverse the elements in between by swapping the ends
    for (++$i, $j = $size; $i < $j; ++$i, --$j)
    { $tmp = $p[$i]; $p[$i] = $p[$j]; $p[$j] = $tmp; }
    return $p;
}

//This function needs to check the current state to see if there are any
function checkBoard($p,$boardX) {
	$a = 0; //this is the row being checked
	while ($a < count($p)) {
		$b = 1;
		while ($b < ($boardX - $a)){
            $x = $p[$a+$b] << $b;
            $y = $p[$a+$b] >> $b;
            if ($p[$a] == $x | $p[$a] == $y) {
                return false;
            }		
            ++$b;
		}
	++$a;
	}
	return true;
}


if (isset($_POST['process']) && isset($_POST['boardX']))
{
//Within here is the code that needs to be run if process is clicked.


//First I need to create the different possible rows
for ($x = 0; $x < $boardX; ++$x){
	$row[$x] = 1 << $x;
}

//Now I need to create all the possible orders of rows, will be equal to [boardY]!
$solcount = 0;
$solutions = array();
while ($row != false) {
	if (checkBoard($row,$boardX)){
	if(!in_array($row,$solutions)){
		$solutions[] = $row;
			renderBoard($row,$boardX);
			$solutions = findRotation($row,$boardX,$solutions);
			++$solcount;
		}

	}
	$row = pc_next_permutation($row);	
}
echo "<br><br>&nbsp&nbsp&nbsp&nbspRows/Columns: ".$boardX."<br>&nbsp&nbsp&nbsp&nbspUnique Solutions: ".$solcount."<br>&nbsp&nbsp&nbsp&nbspTotal Solutions: ".count($solutions)."  - Note: This includes symmetrical solutions<br>";
//print_r($solutions);
}

//This code collects the starting parameters
echo <<<_END
<form name="input" action="index.php" method="post">
&nbsp&nbsp&nbsp&nbspNumber of columns/rows <select name="boardX" />
<option value="1">One</option>
<option value="2">Two</option>
<option value="3">Three</option>
<option value="4" >Four</option>
<option value="5">Five</option>
<option value="6">Six</option>
<option value="7">Seven</option>
<option value="8" selected="selected">Eight</option>
<option value="9">Nine</option>
<option value="10">Ten</option>
</select>
    <input type="hidden" name="process" value="yes" />
&nbsp<input type="submit" value="Process" />
</form>

_END;

?>
</body>
</html>
