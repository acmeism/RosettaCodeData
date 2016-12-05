[System.Collections.ArrayList]$queue = @()
# isEmpty?
if ($queue.Count -eq 0) {
    "isEmpty? result : the queue is empty"
} else {
    "isEmpty? result : the queue is not empty"
}
"the queue contains : $queue"
$queue += 1                    # push
"push result : $queue"
$queue += 2                    # push
$queue += 3                    # push
"push result : $queue"

$queue.RemoveAt(0)             # pop
"pop result : $queue"

$queue.RemoveAt(0)             # pop
"pop result : $queue"

if ($queue.Count -eq 0) {
    "isEmpty? result : the queue is empty"
} else {
    "isEmpty? result : the queue is not empty"
}
"the queue contains : $queue"
