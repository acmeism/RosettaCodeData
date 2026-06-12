// LinkedList.java

// Java provides a doubly-linked list implementation but it doesn't permit
// public access to its internal structure for obvious reasons, so to
// fulfil the task requirements we must implement one ourselves.

import java.util.*;

public class LinkedList<T extends Comparable<? super T>> {
    private final Node<T> sentinel = new Node<T>(null);

    public LinkedList() {
        clear();
    }

    public void clear() {
        sentinel.next = sentinel;
        sentinel.prev = sentinel;
    }

    public boolean isEmpty() {
        return sentinel.next == sentinel;
    }

    public void add(T item) {
        addNode(new Node<T>(item));
    }

    private void addNode(Node<T> n) {
        n.prev = sentinel.prev;
        n.next = sentinel;
        sentinel.prev.next = n;
        sentinel.prev = n;
    }

    public String toString() {
        StringBuilder str = new StringBuilder("[");
        Node<T> n = sentinel.next;
        if (n != sentinel) {
            str.append(n.item);
            n = n.next;
            while (n != sentinel) {
                str.append(", ");
                str.append(n.item);
                n = n.next;
            }
        }
        str.append("]");
        return str.toString();
    }

    public void treeSort() {
        if (isEmpty())
            return;
        Node<T> n = sentinel.next;
        Node<T> root = null;
        while (n != sentinel) {
            Node<T> next = n.next;
            n.next = null;
            n.prev = null;
            root = treeInsert(root, n);
            n = next;
        }
        clear();
        treeToList(root);
    }

    private Node<T> treeInsert(Node<T> tree, Node<T> n) {
        if (tree == null)
            tree = n;
        else if (n.item.compareTo(tree.item) < 0)
            tree.prev = treeInsert(tree.prev, n);
        else
            tree.next = treeInsert(tree.next, n);
        return tree;
    }

    private void treeToList(Node<T> node) {
        if (node == null)
            return;
        Node<T> prev = node.prev;
        Node<T> next = node.next;
        treeToList(prev);
        addNode(node);
        treeToList(next);
    }

    private static class Node<T> {
        private T item;
        private Node<T> prev = null;
        private Node<T> next = null;

        private Node(T item) {
            this.item = item;
        }
    }
}
