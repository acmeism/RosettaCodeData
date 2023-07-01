public class Stack<T>{
    private Node first = null;
    public boolean isEmpty(){
        return first == null;
    }
    public T Pop(){
        if(isEmpty())
            throw new Exception("Can't Pop from an empty Stack.");
        else{
            T temp = first.value;
            first = first.next;
            return temp;
        }
    }
    public void Push(T o){
        first = new Node(o, first);
    }
    class Node{
        public Node next;
        public T value;
        public Node(T value){
            this(value, null);
        }
        public Node(T value, Node next){
            this.next = next;
            this.value = value;
        }
    }
}
