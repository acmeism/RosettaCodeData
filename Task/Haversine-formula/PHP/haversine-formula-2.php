$bna = new POI(36.12, -86.67); // Nashville International Airport
$lax = new POI(33.94, -118.40); // Los Angeles International Airport
printf('%.2f km', $bna->getDistanceInMetersTo($lax));
