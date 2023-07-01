set_time_limit(300);
header("Content-Type: image/png");

class Julia {
	
	static private $started = false;
	
	public static function start() {
		if (!self::$started) {
			self::$started = true;
			new self;
		}
	}
	
	const AXIS_REAL 	= 0;
	const AXIS_IMAGINARY 	= 1;
	const C 		= [-0.75, 0.1];
	const RADII 		= [1, 0.5];
	const CENTER 		= [0, 0];
	const MAX_ITERATIONS 	= 100;
	const TICK_SPACING 	= 0.001;
	
	private $maxDistance;
	private $imageResource;
	private $whiteColorResource;
	private $z0 = [];
	
	private function __construct() {
		$this->maxDistance = max($this->distance(self::C), 2);
		$this->imageResource = imagecreate(
			$this->coordinateToPixel(self::RADII[self::AXIS_REAL], self::AXIS_REAL),
			$this->coordinateToPixel(self::RADII[self::AXIS_IMAGINARY], self::AXIS_IMAGINARY)
		);
		imagecolorallocate($this->imageResource, 0, 0, 0);
		$this->whiteColorResource = imagecolorallocate($this->imageResource, 255, 255, 255);
		
		for ($x = self::CENTER[self::AXIS_REAL] - self::RADII[self::AXIS_REAL];
		$x <= self::CENTER[self::AXIS_REAL] + self::RADII[self::AXIS_REAL]; $x += self::TICK_SPACING) {
			$z0[self::AXIS_REAL] = $x;
			
			for ($y = self::CENTER[self::AXIS_IMAGINARY] - self::RADII[self::AXIS_IMAGINARY];
			$y <= self::CENTER[self::AXIS_IMAGINARY] + self::RADII[self::AXIS_IMAGINARY]; $y += self::TICK_SPACING) {
				$z0[self::AXIS_IMAGINARY] = $y;
				$iterations = 1;
				do {
					$z0 = $this->q($z0);
					$iterations++;
				} while($iterations < self::MAX_ITERATIONS && $this->distance($z0) <= $this->maxDistance);
				
				if ($iterations !== self::MAX_ITERATIONS) {
					imagesetpixel(
						$this->imageResource,
						$this->coordinateToPixel($x, self::AXIS_REAL),
						$this->coordinateToPixel($y, self::AXIS_IMAGINARY),
						$this->whiteColorResource
					);
				}
				$z0[self::AXIS_REAL] = $x;
			}
		}
	}
	
	public function __destruct() {
		imagepng($this->imageResource);
		imagedestroy($this->imageResource);
	}
	
	private function q($z) {
		return [ ($z[self::AXIS_REAL] ** 2) - ($z[self::AXIS_IMAGINARY] ** 2) + self::C[self::AXIS_REAL],
                       (2 * $z[self::AXIS_REAL] * $z[self::AXIS_IMAGINARY]) + self::C[self::AXIS_IMAGINARY] ];
	}
	
	private function distance($z) {
		return sqrt( ($z[self::AXIS_REAL] ** 2) + ($z[self::AXIS_IMAGINARY] ** 2) );
	}
	
	private function coordinateToPixel($coordinate, $axis) {
		return ($coordinate + self::RADII[$axis]) * (self::TICK_SPACING ** -1);
	}
}

Julia::start();
