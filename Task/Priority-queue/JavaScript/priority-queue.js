class Task {
    constructor(priority, name) {
        this.priority = priority;
        this.name = name;
    }

    toString() {
        return `${this.priority}, ${this.name}`;
    }
}

class PriorityQueue {
    constructor() {
        this.heap = [];
    }

    // Add a task to the heap
    add(task) {
        this.heap.push(task);
        this.bubbleUp(this.heap.length - 1);
    }

    // Remove and return the highest priority task
    remove() {
        if (this.heap.length === 0) return null;
        const min = this.heap[0];
        const end = this.heap.pop();
        if (this.heap.length > 0) {
            this.heap[0] = end;
            this.bubbleDown(0);
        }
        return min;
    }

    // Check if the queue is empty
    isEmpty() {
        return this.heap.length === 0;
    }

    // Move the element at index `i` up the heap
    bubbleUp(i) {
        const element = this.heap[i];
        while (i > 0) {
            const parentIndex = Math.floor((i - 1) / 2);
            const parent = this.heap[parentIndex];
            if (element.priority >= parent.priority) break;
            this.heap[i] = parent;
            i = parentIndex;
        }
        this.heap[i] = element;
    }

    // Move the element at index `i` down the heap
    bubbleDown(i) {
        const element = this.heap[i];
        const length = this.heap.length;
        while (true) {
            const leftChildIndex = 2 * i + 1;
            const rightChildIndex = 2 * i + 2;
            let leftChild, rightChild;
            let swap = null;

            if (leftChildIndex < length) {
                leftChild = this.heap[leftChildIndex];
                if (leftChild.priority < element.priority) {
                    swap = leftChildIndex;
                }
            }
            if (rightChildIndex < length) {
                rightChild = this.heap[rightChildIndex];
                if (
                    (swap === null && rightChild.priority < element.priority) ||
                    (swap !== null && rightChild.priority < leftChild.priority)
                ) {
                    swap = rightChildIndex;
                }
            }
            if (swap === null) break;
            this.heap[i] = this.heap[swap];
            i = swap;
        }
        this.heap[i] = element;
    }
}

// Usage
const pq = new PriorityQueue();
pq.add(new Task(3, "Clear drains"));
pq.add(new Task(4, "Feed cat"));
pq.add(new Task(5, "Make tea"));
pq.add(new Task(1, "Solve RC tasks"));
pq.add(new Task(2, "Tax return"));

while (!pq.isEmpty()) {
    console.log(pq.remove().toString());
}
