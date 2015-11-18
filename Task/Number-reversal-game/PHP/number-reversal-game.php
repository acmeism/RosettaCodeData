class ReversalGame {
    private $numbers;

    public function __construct() {
        $this->initialize();
    }

    public function play() {
        $i = 0;
        $moveCount = 0;
        while (true) {
            echo json_encode($this->numbers) . "\n";
            echo "Please enter an index to reverse from 2 to 9. Enter 99 to quit\n";
            $i = intval(rtrim(fgets(STDIN), "\n"));
            if ($i == 99) {
                break;
            }
            if ($i < 2 || $i > 9) {
                echo "Invalid input\n";
            } else {
                $moveCount++;
                $this->reverse($i);
                if ($this->isSorted()) {
                    echo "Congratulations you solved this in $moveCount moves!\n";
                    break;
                }
            }

        }
    }

    private function reverse($position) {
        array_splice($this->numbers, 0, $position, array_reverse(array_slice($this->numbers, 0, $position)));
    }

    private function isSorted() {
        for ($i = 0; $i < count($this->numbers) - 1; ++$i) {
            if ($this->numbers[$i] > $this->numbers[$i + 1]) {
                return false;
            }
        }
        return true;
    }

    private function initialize() {
        $this->numbers = range(1, 9);
        while ($this->isSorted()) {
            shuffle($this->numbers);
        }
    }

}

$game = new ReversalGame();
$game->play();
