#!/usr/bin/awk -f
{
    if ($1 ~ "^"$2) {
	print $1" begins with "$2;
    } else {
	print $1" does not begin with "$2;
    }

    if ($1 ~ $2) {
	print $1" contains "$2;
    } else {
	print $1" does not contain "$2;
    }

    if ($1 ~ $2"$") {
	print $1" ends with "$2;
    } else {
	print $1" does not end with "$2;
    }
}
