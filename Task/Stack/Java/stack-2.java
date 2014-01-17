public class Stack{
    private Node first = null;
    public boolean isEmpty(){
        return first == null;
    }
    public Object Pop(){
        if(isEmpty())
            throw new Exception("Can't Pop from an empty Stack.");
        else{
            Object temp = first.value;
            first = first.next;
            return temp;
        }
    }
    public void Push(Object o){
        first = new Node(o, first);
    }
    class Node{
        public Node next;
        public Object value;
        public Node(Object value){
            this(value, null);
        }
        public Node(Object value, Node next){
            this.next = next;
            this.value = value;
        }
    }
}
