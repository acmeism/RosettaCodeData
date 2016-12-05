[]
| resides("Baker";  . != top)                     # Baker does not live on the top floor
| resides("Cooper"; . != bottom)                  # Cooper does not live on the bottom floor
| resides("Fletcher"; . != top and . != bottom)   # Fletcher does not live on either the top or the bottom floor.
| index("Cooper") as $Cooper
| resides("Miller"; higher( $Cooper) )            # Miller lives on a higher floor than does Cooper
| index("Fletcher") as $Fletcher
| resides("Smith"; adjacent($Fletcher) | not)     # Smith does not live on a floor adjacent to Fletcher's.
| select( $Fletcher | adjacent( $Cooper ) | not ) # Fletcher does not live on a floor adjacent to Cooper's.
