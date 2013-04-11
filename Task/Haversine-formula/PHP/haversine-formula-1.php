class POI {
    private $latitude;
    private $longitude;
    public function __construct($latitude, $longitude) {
        $this->latitude = deg2rad($latitude);
        $this->longitude = deg2rad($longitude);
    }
    public function getLatitude() return $this->latitude;
    public function getLongitude() return $this->longitude;
    public function getDistanceInMetersTo(POI $other) {
        $radiusOfEarth = 6371000;// Earth's radius in meters.
        $diffLatitude = $other->getLatitude() - $this->latitude;
        $diffLongitude = $other->getLongitude() - $this->longitude;
        $a = sin($diffLatitude / 2) * sin($diffLatitude / 2) +
            cos($this->latitude) * cos($other->getLatitude()) *
            sin($diffLongitude / 2) * sin($diffLongitude / 2);
        $c = 2 * asin(sqrt($a));
        $distance = $radiusOfEarth * $c;
        return $distance;
    }
}
