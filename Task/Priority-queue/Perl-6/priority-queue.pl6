class PriorityQueue {
    has @!tasks;

    method insert (Int $priority where * >= 0, $task) {
        @!tasks[$priority].push: $task;
    }

    method get { @!tasks.first(?*).shift }

    method is-empty { ?none @!tasks }
}

my $pq = PriorityQueue.new;

for (
    3, 'Clear drains',
    4, 'Feed cat',
    5, 'Make tea',
    9, 'Sleep',
    3, 'Check email',
    1, 'Solve RC tasks',
    9, 'Exercise',
    2, 'Do taxes'
) -> $priority, $task {
    $pq.insert( $priority, $task );
}

say $pq.get until $pq.is-empty;
