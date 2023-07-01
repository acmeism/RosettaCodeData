<?php
class Maze
{
    protected $width;
    protected $height;
    protected $grid;
    protected $path;
    protected $horWalls;
    protected $vertWalls;
    protected $dirs;
    protected $isDebug;

    public function __construct($x, $y, $debug = false)
    {
        $this->width = $x;
        $this->height = $y;
        $this->path = [];
        $this->dirs = [ [0, -1], [0, 1], [-1, 0], [1, 0]]; // array of coordinates of N,S,W,E
        $this->horWalls = []; // list of removed horizontal walls (---+)
        $this->vertWalls = [];// list of removed vertical walls (|)
        $this->isDebug = $debug; // debug flag

        // generate the maze:
        $this->generate();
    }

    protected function generate()
    {
        $this->initMaze(); // init the stack and an unvisited grid
        // start from a random cell and then proceed recursively
        $this->walk(mt_rand(0, $this->width-1), mt_rand(0, $this->height-1));
    }

    /**
    * Actually prints the Maze, on stdOut. Put in a separate method to allow extensibility
    * For simplicity sake doors are positioned on the north wall and east wall
    */
    public function printOut()
    {
        $this->log("Horizontal walls: %s", json_encode($this->horWalls));
        $this->log("Vertical walls: %s", json_encode($this->vertWalls));

        $northDoor = mt_rand(0,$this->width-1);
        $eastDoor = mt_rand(0, $this->height-1);

        $str = '+';
        for ($i=0;$i<$this->width;$i++) {
            $str .= ($northDoor == $i) ? '   +' : '---+';
        }
        $str .= PHP_EOL;
        for ($i=0; $i<$this->height; $i++) {

            for ($j=0; $j<$this->width; $j++) {
                $str .= (!empty($this->vertWalls[$j][$i]) ? $this->vertWalls[$j][$i] : '|   ');
            }
            $str .= ($i == $eastDoor ? '  ' : '|').PHP_EOL.'+';
            for ($j=0; $j<$this->width; $j++) {
                $str .= (!empty($this->horWalls[$j][$i]) ? $this->horWalls[$j][$i] : '---+');
            }
            $str .= PHP_EOL;
        }
        echo $str;
    }

    /**
    * Logs to stdOut if debug flag is enabled
    */
    protected function log(...$params)
    {
        if ($this->isDebug) {
            echo vsprintf(array_shift($params), $params).PHP_EOL;
        }
    }

    private function walk($x, $y)
    {
        $this->log('Entering cell %d,%d', $x, $y);
        // mark current cell as visited
        $this->grid[$x][$y] = true;
        // add cell to path
        $this->path[] = [$x, $y];
        // get list of all neighbors
        $neighbors = $this->getNeighbors($x, $y);
        $this->log("Valid neighbors: %s", json_encode($neighbors));

        if(empty($neighbors)) {
            // Dead end, we need now to backtrack, if there's still any cell left to be visited
            $this->log("Start backtracking along path: %s", json_encode($this->path));
            array_pop($this->path);
            if (!empty($this->path)) {
                $next = array_pop($this->path);
                return $this->walk($next[0], $next[1]);
            }
        } else {
            // randomize neighbors, as per request
            shuffle($neighbors);

            foreach ($neighbors as $n) {
                $nextX = $n[0];
                $nextY = $n[1];
                if ($nextX == $x) {
                    $wallY = max($nextY, $y);
                    $this->log("New cell is on the same column (%d,%d), removing %d, (%d-1) horizontal wall", $nextX, $nextY, $x, $wallY);
                    $this->horWalls[$x][min($nextY, $y)] = "   +";
                }
                if ($nextY == $y) {
                    $wallX = max($nextX, $x);
                    $this->log("New cell is on the same row (%d,%d), removing %d,%d vertical wall", $nextX, $nextY, $wallX, $y);
                    $this->vertWalls[$wallX][$y] = "    ";
                }
                return $this->walk($nextX, $nextY);
            }
        }
    }

    /**
    * Initialize an empty grid of $width * $height dimensions
    */
    private function initMaze()
    {
        for ($i=0;$i<$this->width;$i++) {
            for ($j = 0;$j<$this->height;$j++) {
                $this->grid[$i][$j] = false;
            }
        }
    }

    /**
    * @param int $x
    * @param int $y
    * @return array
    */
    private function getNeighbors($x, $y)
    {
        $neighbors = [];
        foreach ($this->dirs as $dir) {
            $nextX = $dir[0] + $x;
            $nextY = $dir[1] + $y;
            if (($nextX >= 0 && $nextX < $this->width && $nextY >= 0 && $nextY < $this->height) && !$this->grid[$nextX][$nextY]) {
                $neighbors[] = [$nextX, $nextY];
            }
        }
        return $neighbors;
    }
}

$maze = new Maze(10,10);
$maze->printOut();
