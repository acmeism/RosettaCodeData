/[0-9]* [0-9]*/{
		if ($1 == $2) print $1, "is equal to", $2
		if ($1 < $2) print $1, "is less than", $2
		if ($1 > $2) print $1, "is greater than", $2
		}
