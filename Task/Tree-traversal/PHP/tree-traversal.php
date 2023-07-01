class Node {
    private $left;
    private $right;
    private $value;

    function __construct($value) {
        $this->value = $value;
    }

    public function getLeft() {
        return $this->left;
    }
    public function getRight() {
        return $this->right;
    }
    public function getValue() {
        return $this->value;
    }

    public function setLeft($value) {
        $this->left = $value;
    }
    public function setRight($value) {
        $this->right = $value;
    }
    public function setValue($value) {
        $this->value = $value;
    }
}

class TreeTraversal {

    public function preOrder(Node $n) {
        echo $n->getValue() . " ";
        if($n->getLeft() != null) {
            $this->preOrder($n->getLeft());
        }
        if($n->getRight() != null){
            $this->preOrder($n->getRight());
        }
    }

    public function inOrder(Node $n) {
        if($n->getLeft() != null) {
            $this->inOrder($n->getLeft());
        }
        echo $n->getValue() . " ";
        if($n->getRight() != null){
            $this->inOrder($n->getRight());
        }

    }

    public function postOrder(Node $n) {
        if($n->getLeft() != null) {
            $this->postOrder($n->getLeft());
        }
        if($n->getRight() != null){
            $this->postOrder($n->getRight());
        }
        echo $n->getValue() . " ";
    }

    public function levelOrder($arg) {
        $q[] = $arg;
        while (!empty($q)) {
            $n = array_shift($q);
            echo $n->getValue() . " ";
            if($n->getLeft() != null) {
                $q[] = $n->getLeft();
            }
            if($n->getRight() != null){
                $q[] = $n->getRight();
            }
        }
    }
}

$arr = [];
for ($i=1; $i < 10; $i++) {
    $arr[$i] = new Node($i);
}

$arr[6]->setLeft($arr[8]);
$arr[6]->setRight($arr[9]);
$arr[3]->setLeft($arr[6]);
$arr[4]->setLeft($arr[7]);
$arr[2]->setLeft($arr[4]);
$arr[2]->setRight($arr[5]);
$arr[1]->setLeft($arr[2]);
$arr[1]->setRight($arr[3]);

$tree = new TreeTraversal($arr);

echo "preorder:\t";
$tree->preOrder($arr[1]);
echo "\ninorder:\t";
$tree->inOrder($arr[1]);
echo "\npostorder:\t";
$tree->postOrder($arr[1]);
echo "\nlevel-order:\t";
$tree->levelOrder($arr[1]);
