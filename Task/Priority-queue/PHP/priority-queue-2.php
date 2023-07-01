<?php
$pq = new SplMinHeap;

$pq->insert(array(3, 'Clear drains'));
$pq->insert(array(4, 'Feed cat'));
$pq->insert(array(5, 'Make tea'));
$pq->insert(array(1, 'Solve RC tasks'));
$pq->insert(array(2, 'Tax return'));

while (!$pq->isEmpty()) {
    print_r($pq->extract());
}
?>
