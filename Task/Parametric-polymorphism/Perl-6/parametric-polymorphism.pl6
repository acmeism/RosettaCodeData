role BinaryTree[::T] {
    has T $.value;
    has BinaryTree[T] $.left;
    has BinaryTree[T] $.right;

    method replace-all(T $value) {
        $!value = $value;
        $!left.replace-all($value) if $!left.defined;
        $!right.replace-all($value) if $!right.defined;
    }
}

class IntTree does BinaryTree[Int] { }

my IntTree $it .= new(value => 1,
                      left  => IntTree.new(value => 2),
                      right => IntTree.new(value => 3));

$it.replace-all(42);
say $it.perl;
