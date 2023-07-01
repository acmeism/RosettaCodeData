import java.util.LinkedList;
...
LinkedList queue = new LinkedList();
System.out.println(queue.isEmpty());      // empty test - true
queue.add(new Integer(1));
queue.add(new Integer(2));
queue.add(new Integer(3));
System.out.println(queue);                // [1, 2, 3]
System.out.println(queue.removeFirst());  // 1
System.out.println(queue);                // [2, 3]
System.out.println(queue.isEmpty());      // false
