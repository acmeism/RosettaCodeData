$user = new POI($_GET["latitude"], $_GET["longitude"]);
$poi = new POI(19,69276, -98,84350); // Piramide del Sol, Mexico
echo $user->getDistanceInMetersTo($poi);
