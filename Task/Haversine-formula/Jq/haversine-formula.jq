def haversine(lat1;lon1; lat2;lon2):
  def radians: . * (1|atan)/45;
  def sind: radians|sin;
  def cosd: radians|cos;
  def sq: . * .;

    (((lat2 - lat1)/2) | sind | sq) as $dlat
  | (((lon2 - lon1)/2) | sind | sq) as $dlon
  | 2 * 6372.8 * (( $dlat + (lat1|cosd) * (lat2|cosd) * $dlon ) | sqrt | asin) ;
