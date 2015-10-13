class PriorityQueue {
    has @!tasks;

    method insert (Int $priority where * >= 0, $task) {
        @!tasks[$priority].push: $task;
    }

    method get { @!tasks.first(?*).shift }

    method is-empty { ?none @!tasks }
}
