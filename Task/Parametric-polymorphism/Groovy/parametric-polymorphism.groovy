class Tree<T> {
    T value
    Tree<T> left
    Tree<T> right

    Tree(T value = null, Tree<T> left = null, Tree<T> right = null) {
        this.value = value
        this.left = left
        this.right = right
    }

    void replaceAll(T value) {
        this.value = value
        left?.replaceAll(value)
        right?.replaceAll(value)
    }
}
