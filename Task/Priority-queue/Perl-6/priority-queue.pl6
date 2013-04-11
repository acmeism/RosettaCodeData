class PriorityQueue {
    has @!tasks is rw;

    method insert ( Int $priority where { $priority >= 0 }, $task ) {
        @!tasks[$priority] //= [];
        @!tasks[$priority].push: $task;
    }

    method get { @!tasks.first({$^_}).shift }

    method is_empty { !?@!tasks.first({$^_}) }
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

say $pq.get until $pq.is_empty;
