Filter FromRoman {
	$output = 0
	
	if ($_ -notmatch '^(M{1,3}|)(CM|CD|D?C{0,3}|)(XC|XL|L?X{0,3}|)(IX|IV|V?I{0,3}|)$') {
		throw 'Incorrect format'
	}
	
	$current = 1000
	$subtractor = 'M'
	$whole = $False
	$roman = $_
	'C','D','X','L','I','V',' ' `
	| %{
		if ($whole = !$whole) {
			$current /= 10
			$subtractor = $_ + $subtractor[0]
			$_ = $subtractor[1]
		}
		else {
			$subtractor = $subtractor[0] + $_
		}
		
		if ($roman -match $subtractor) {
			$output += $current * (4,9)[$whole]
			$roman = $roman -replace $subtractor,''
		}
		if ($roman -match ($_ + '{1,3}')) {
			$output += $current * (5,10)[$whole] * $Matches[0].Length
		}
	}
	
	$output
}
