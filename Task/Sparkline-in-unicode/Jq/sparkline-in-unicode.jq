def sparkline:
  min as $min
  | ( (max - $min) / 7 ) as $div
  | map( 9601 +  (. - $min) * $div )
  | implode ;

def string2array:
  def tidy: select( length > 0 );
  [split(" ") | .[] | split(",") | .[] | tidy | tonumber];
