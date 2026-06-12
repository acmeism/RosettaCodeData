def lst: [2, 43, 81, 122, 63, 13, 7, 95, 103];

lst | map( select(is_prime) ) | sort
