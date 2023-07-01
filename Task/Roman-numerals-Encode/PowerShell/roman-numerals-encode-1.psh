Filter ToRoman {
	$output = ''
	
	if ($_ -ge 4000) {
		throw 'Number too high'
	}
	
	$current = 1000
	$subtractor = 'M'
	$whole = $False
	$decimal = $_
	'C','D','X','L','I','V',' ' `
	| %{
		$divisor = $current
		if ($whole = !$whole) {
			$current /= 10
			$subtractor = $_ + $subtractor[0]
			$_ = $subtractor[1]
		}
		else {
			$divisor *= 5
			$subtractor = $subtractor[0] + $_
		}
		
		$multiple = [Math]::floor($decimal / $divisor)
		if ($multiple) {
			$output += [string]$_ * $multiple
			$decimal %= $divisor
		}
		if ($decimal -ge ($divisor -= $current)) {
			$output += $subtractor
			$decimal -= $divisor
		}
	}
	
	$output
}
