function multiples($param1, &$param2) {
	if ($param1 == 'bob') {
		$param2 = 'is your grandmother';
		return true;
	}
	
	return false;
}

echo 'First run: ' . multiples('joe', $y) . "\r\n";
echo "Param 2 from first run: '${y}'\r\n";

echo 'Second run: ' . multiples('bob', $y) . "\r\n";
echo "Param 2 from second run: '${y}'\r\n";
