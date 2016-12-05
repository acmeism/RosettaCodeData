	class SudokuSolver {
		protected $grid = [];
		protected $emptySymbol;
		public static function parseString($str, $emptySymbol = '0')
		{
			$grid = str_split($str);
			foreach($grid as &$v)
			{
				if($v == $emptySymbol)
				{
					$v = 0;
				}
				else
				{
					$v = (int)$v;
				}
			}
			return $grid;
		}
		
		public function __construct($str, $emptySymbol = '0') {
			if(strlen($str) !== 81)
			{
				throw new \Exception('Error sudoku');
			}
			$this->grid = static::parseString($str, $emptySymbol);
			$this->emptySymbol = $emptySymbol;
		}
		
		public function solve()
		{
			try
			{
				$this->placeNumber(0);
				return false;
			}
			catch(\Exception $e)
			{
				return true;
			}
		}
		
		protected function placeNumber($pos)
		{
			if($pos == 81)
			{
				throw new \Exception('Finish');
			}
			if($this->grid[$pos] > 0)
			{
				$this->placeNumber($pos+1);
				return;
			}
			for($n = 1; $n <= 9; $n++)
			{
				if($this->checkValidity($n, $pos%9, floor($pos/9)))
				{
					$this->grid[$pos] = $n;
					$this->placeNumber($pos+1);
					$this->grid[$pos] = 0;
				}
			}
		}
		
		protected function checkValidity($val, $x, $y)
		{
			for($i = 0; $i < 9; $i++)
			{
				if(($this->grid[$y*9+$i] == $val) || ($this->grid[$i*9+$x] == $val))
				{
					return false;
				}
			}
			$startX = (int) ((int)($x/3)*3);
			$startY = (int) ((int)($y/3)*3);

			for($i = $startY; $i<$startY+3;$i++)
			{
				for($j = $startX; $j<$startX+3;$j++)
				{
					if($this->grid[$i*9+$j] == $val)
					{
						return false;
					}
				}
			}
			return true;
		}

		public function display() {
			$str = '';
			for($i = 0; $i<9; $i++)
			{
				for($j = 0; $j<9;$j++)
				{
					$str .= $this->grid[$i*9+$j];
					$str .= " ";
					if($j == 2 || $j == 5)
					{
						$str .= "| ";
					}
				}
				$str .= PHP_EOL;
				if($i == 2 || $i == 5)
				{
					$str .=  "------+-------+------".PHP_EOL;
				}
			}
			echo $str;
		}
		
		public function __toString() {
			foreach ($this->grid as &$item)
			{
				if($item == 0)
				{
					$item = $this->emptySymbol;
				}
			}
			return implode('', $this->grid);
		}
	}
	$solver = new SudokuSolver('009170000020600001800200000200006053000051009005040080040000700006000320700003900');
	$solver->solve();
	$solver->display();
