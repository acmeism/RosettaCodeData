$Q = New-Object System.Collections.Queue

$Q.Enqueue( 1 )
$Q.Enqueue( 2 )
$Q.Enqueue( 3 )

$Q.Dequeue()
$Q.Dequeue()

$Q.Count -eq 0
$Q.Dequeue()
$Q.Count -eq 0

try
{ $Q.Dequeue() }
catch [System.InvalidOperationException]
{ If ( $_.Exception.Message -eq 'Queue empty.' ) { 'Caught error' } }
