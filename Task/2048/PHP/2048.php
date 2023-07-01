<?php

$game = new Game();

while(true) {
    $game->cycle();
}

class Game {
	private $field;
	private $fieldSize;
	private $command;
	private $error;
	private $lastIndexX, $lastIndexY;
	private $score;
	private $finishScore;

	function __construct() {
		$this->field = array();
		$this->fieldSize = 4;
		$this->finishScore = 2048;
		$this->score = 0;
		$this->addNumber();
		$this->render();
	}

	public function cycle() {
		$this->command = strtolower($this->readchar('Use WASD, q exits'));
		$this->cls();

		if($this->processCommand()) {
			$this->addNumber();
		} else {
			if(count($this->getFreeList()) == 0 ) {
				$this->error = 'No options left!, You Lose!!';
			} else {
				$this->error = 'Invalid move, try again!';
			}
		}
		$this->render();
	}

	private function readchar($prompt) {
		readline_callback_handler_install($prompt, function() {});
		$char = stream_get_contents(STDIN, 1);
		readline_callback_handler_remove();
		return $char;
	}

	/**
	 * Insert a number in an empty spot on the field
	 */
	private function addNumber() {
		$freeList = $this->getFreeList();
		if(count($freeList) == 0) {
			return;
		}
		$index = mt_rand(0, count($freeList)-1);
		$nr = (mt_rand(0,9) == 0)? 4 : 2;
		$this->field[$freeList[$index]['x']][$freeList[$index]['y']] = $nr;
		return;
	}

	/**
	 * @return array(array('x' => <x>, 'y' => <y>)) with empty positions in the field
	 */
	private function getFreeList() {
		$freeList = array();
		for($y =0; $y< $this->fieldSize;$y++) {
			for($x=0; $x < $this->fieldSize; $x++) {
				if(!isset($this->field[$x][$y])) {
					$freeList[] = array('x' => $x, 'y' => $y);
				} elseif($this->field[$x][$y] == $this->finishScore) {
					$this->error = 'You Win!!';
				}
			}
		}
		return $freeList;
	}

	/**
	 * Process a command:
	 * @return is the command valid (Did it cause a change in the field)
	 */
	private function processCommand() {
		if(!in_array($this->command, array('w','a','s','d','q'))) {
			$this->error = 'Invalid Command';
			return false;
		}
		if($this->command == 'q') {
			echo PHP_EOL. 'Bye!'. PHP_EOL;
			exit;
		}

		// Determine over which axis and in which direction we move:
		$axis = 'x';
		$sDir = 1;

		switch($this->command) {
			case 'w':
				$axis = 'y';
				$sDir = -1;
				break;
			case 'a':
				$sDir = -1;
				break;
			case 's':
				$axis = 'y';
				break;
			case 'd':
			break;
		}

		$done = 0;
		// shift all numbers in that direction
		$done += $this->shift($axis, $sDir);
		// merge equal numbers in opposite direction
		$done += $this->merge($axis, $sDir * -1);
		// shift merged numbers in that direction
		$done += $this->shift($axis, $sDir);
		return $done >0;
	}

	private function shift($axis, $dir) {
		$totalDone = 0;
		for($i = 0; $i <$this->fieldSize; $i++) {
			$done = 0;
			foreach($this->iterate($axis,$dir) as $xy) {
				if($xy['vDest'] === NULL && $xy['vSrc'] !== NULL) {
					$this->field[$xy['dX']][$xy['dY']] = $xy['vSrc'];
					$this->field[$xy['sX']][$xy['sY']] = NULL;
					$done++;
				}
			}
			$totalDone += $done;
			if($done == 0) {
				// nothing to shift anymore
				break;
			}
		}
		return $totalDone;
	}

	private function merge($axis, $dir) {
		$done = 0;
		foreach($this->iterate($axis,$dir) as $xy) {
			if($xy['vDest'] !== NULL && $xy['vDest'] === $xy['vSrc']) {
				$this->field[$xy['sX']][$xy['sY']] += $xy['vDest'];
				$this->field[$xy['dX']][$xy['dY']] = NULL;
				$this->score += $this->field[$xy['sX']][$xy['sY']];
				$done ++;
			}
		}
		return $done;
	}

	/**
	 * @return array List of src, dest pairs and their values to iterate over.
	 */
	private function iterate($axis, $dir) {
		$res = array();
		for($y = 0; $y < $this->fieldSize; $y++) {
			for($x=0; $x < $this->fieldSize; $x++) {
				$item = array('sX'=> $x,'sY' => $y, 'dX' => $x, 'dY' => $y, 'vDest' => NULL,'vSrc' => NULL);
				
				if($axis == 'x') {
					$item['dX'] += $dir;
				} else {
					$item['dY'] += $dir;
				}

				if($item['dX'] >= $this->fieldSize || $item['dY'] >=$this->fieldSize || $item['dX'] < 0 || $item['dY'] < 0) {
					continue;
				}

				$item['vDest'] = (isset($this->field[$item['dX']][$item['dY']]))? $this->field[$item['dX']][$item['dY']] : NULL;
				$item['vSrc'] = (isset($this->field[$item['sX']][$item['sY']]))? $this->field[$item['sX']][$item['sY']] : NULL;
				$res[] = $item;
			}
		}
		if($dir < 0) {
			$res = array_reverse($res);
		}
		return $res;
	}

	/// RENDER ///

	/**
	 * Clear terminal screen
	 */
	private function cls() {
		echo chr(27).chr(91).'H'.chr(27).chr(91).'J';
	}

	private function render() {
		echo $this->finishScore . '! Current score: '. $this->score .PHP_EOL;

		if(!empty($this->error)) {
			echo $this->error . PHP_EOL;
			$this->error = NULL;
		}
		$this->renderField();
	}

	private function renderField() {
		$width = 5;
		$this->renderVSeperator($width);
		for($y =0; $y < $this->fieldSize; $y ++) {
			for($x = 0;$x < $this->fieldSize; $x++) {
				echo '|';
				if(!isset($this->field[$x][$y])) {
					echo str_repeat(' ', $width);
					continue;
				}
				printf('%'.$width.'s', $this->field[$x][$y]);
			}
			echo '|'. PHP_EOL;
			$this->renderVSeperator($width);
		}
	}

	private function renderVSeperator($width) {
		echo str_repeat('+'. str_repeat('-', $width), $this->fieldSize) .'+' .PHP_EOL;
	}

}
