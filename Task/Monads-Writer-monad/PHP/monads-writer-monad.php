class WriterMonad {

	/** @var mixed */
	private $value;
	/** @var string[] */
	private $logs;

	private function __construct($value, array $logs = []) {
		$this->value = $value;
		$this->logs = $logs;
	}

	public static function unit($value, string $log): WriterMonad {
		return new WriterMonad($value, ["{$log}: {$value}"]);
	}

	public function bind(callable $mapper): WriterMonad  {
		$mapped = $mapper($this->value);
		assert($mapped instanceof WriterMonad);
		return new WriterMonad($mapped->value, [...$this->logs, ...$mapped->logs]);
	}

	public function value() {
		return $this->value;
	}

	public function logs(): array {
		return $this->logs;
	}
}

$root = fn(float $i): float => sqrt($i);
$addOne = fn(float $i): float => $i + 1;
$half = fn(float $i): float => $i / 2;

$m = fn (callable $callback, string $log): callable => fn ($value): WriterMonad => WriterMonad::unit($callback($value), $log);

$result = WriterMonad::unit(5, "Initial value")
	->bind($m($root, "square root"))
	->bind($m($addOne, "add one"))
	->bind($m($half, "half"));

print "The Golden Ratio is: {$result->value()}\n";
print join("\n", $result->logs());
