import java.util.LinkedList;
import java.util.Queue;
...
Queue<Integer> queue = new LinkedList<Integer>();
System.out.println(queue.isEmpty());      // empty test - true
// queue.remove();       // would throw NoSuchElementException
queue.add(1);
queue.add(2);
queue.add(3);
System.out.println(queue);                // [1, 2, 3]
System.out.println(queue.remove());       // 1
System.out.println(queue);                // [2, 3]
System.out.println(queue.isEmpty());      // false
