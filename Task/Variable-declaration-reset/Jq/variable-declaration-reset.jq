[1,2,2,3,4,4,5]
| . as $array
| range(1;length)
| select( $array[.] == $array[.-1])
