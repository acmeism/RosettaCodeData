<?php
$pq = new SplPriorityQueue;

$pq->insert('Clear drains', 3);
$pq->insert('Feed cat', 4);
$pq->insert('Make tea', 5);
$pq->insert('Solve RC tasks', 1);
$pq->insert('Tax return', 2);

// This line causes extract() to return both the data and priority (in an associative array),
// Otherwise it would just return the data
$pq->setExtractFlags(SplPriorityQueue::EXTR_BOTH);

while (!$pq->isEmpty()) {
    print_r($pq->extract());
}
?>
