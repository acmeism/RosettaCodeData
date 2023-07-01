import java.util.LinkedList;

public class DoublyLinkedList {

    public static void main(String[] args) {
        LinkedList<String> list = new LinkedList<String>();
        list.addFirst("Add First");
        list.addLast("Add Last 1");
        list.addLast("Add Last 2");
        list.addLast("Add Last 1");
        traverseList(list);

        list.removeFirstOccurrence("Add Last 1");
        traverseList(list);
    }

    private static void traverseList(LinkedList<String> list) {
        System.out.println("Traverse List:");
        for ( int i = 0 ; i < list.size() ; i++ ) {
            System.out.printf("Element number %d - Element value = '%s'%n", i, list.get(i));
        }
        System.out.println();
    }

}
