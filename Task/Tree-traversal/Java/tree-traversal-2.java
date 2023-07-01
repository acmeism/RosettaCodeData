import java.util.function.Consumer;
import java.util.Queue;
import java.util.LinkedList;

class TreeTraversal {
  static class EmptyNode {
    void accept(Visitor aVisitor) {}

    void accept(LevelOrder aVisitor, Queue<EmptyNode> data) {}
  }

  static class Node<T> extends EmptyNode {
    T data;
    EmptyNode left = new EmptyNode();
    EmptyNode right = new EmptyNode();

    Node(T data) {
      this.data = data;
    }

    Node<T> left(Node<?> aNode) {
      this.left = aNode;
      return this;
    }

    Node<T> right(Node<?> aNode) {
      this.right = aNode;
      return this;
    }

    void accept(Visitor aVisitor) {
      aVisitor.visit(this);
    }

    void accept(LevelOrder aVisitor, Queue<EmptyNode> data) {
      aVisitor.visit(this, data);
    }
  }

  static abstract class Visitor {
    Consumer<Node<?>> action;

    Visitor(Consumer<Node<?>> action) {
      this.action = action;
    }

    abstract <T> void visit(Node<T> aNode);
  }

  static class PreOrder extends Visitor {
    PreOrder(Consumer<Node<?>> action) {
      super(action);
    }

    <T> void visit(Node<T> aNode) {
      action.accept(aNode);
      aNode.left.accept(this);
      aNode.right.accept(this);
    }
  }

  static class InOrder extends Visitor {
    InOrder(Consumer<Node<?>> action) {
      super(action);
    }

    <T> void visit(Node<T> aNode) {
      aNode.left.accept(this);
      action.accept(aNode);
      aNode.right.accept(this);
    }
  }

  static class PostOrder extends Visitor {
    PostOrder(Consumer<Node<?>> action) {
      super(action);
    }

    <T> void visit(Node<T> aNode) {
      aNode.left.accept(this);
      aNode.right.accept(this);
      action.accept(aNode);
    }
  }

  static class LevelOrder extends Visitor {
    LevelOrder(Consumer<Node<?>> action) {
      super(action);
    }

    <T> void visit(Node<T> aNode) {
      Queue<EmptyNode> queue = new LinkedList<>();
      queue.add(aNode);
      do {
        queue.remove().accept(this, queue);
      } while (!queue.isEmpty());
    }

    <T> void visit(Node<T> aNode, Queue<EmptyNode> queue) {
      action.accept(aNode);
      queue.add(aNode.left);
      queue.add(aNode.right);
    }
  }

  public static void main(String[] args) {
    Node<Integer> tree = new Node<Integer>(1)
                          .left(new Node<Integer>(2)
                            .left(new Node<Integer>(4)
                              .left(new Node<Integer>(7)))
                            .right(new Node<Integer>(5)))
                          .right(new Node<Integer>(3)
                            .left(new Node<Integer>(6)
                              .left(new Node<Integer>(8))
                              .right(new Node<Integer>(9))));
    Consumer<Node<?>> print = aNode -> System.out.print(aNode.data + " ");
    tree.accept(new PreOrder(print));
    System.out.println();
    tree.accept(new InOrder(print));
    System.out.println();
    tree.accept(new PostOrder(print));
    System.out.println();
    tree.accept(new LevelOrder(print));
    System.out.println();
  }
}
