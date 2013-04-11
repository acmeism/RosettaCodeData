Option Explicit

sub verifydistribution(calledfunction, samples, delta)
	Dim i, n, maxdiff
	'We could cheat via Dim d(7), but "7" wasn't mentioned in the Task. Heh.
	Dim d : Set d = CreateObject("Scripting.Dictionary")
	wscript.echo "Running """ & calledfunction & """ " & samples & " times..."
	for i = 1 to samples
		Execute "n = " & calledfunction
		d(n) = d(n) + 1
	next
	n = d.Count
	maxdiff = 0
	wscript.echo "Expected average count is " & Int(samples/n) & " across " & n & " buckets."
	for each i in d.Keys
		dim diff : diff = abs(1 - d(i) / (samples/n))
		if diff > maxdiff then maxdiff = diff
		wscript.echo "Bucket " & i & " had " & d(i) & " occurences" _
		& vbTab & " difference from expected=" & FormatPercent(diff, 2)
	next
	wscript.echo "Maximum found variation is " & FormatPercent(maxdiff, 2) _
		& ", desired limit is " & FormatPercent(delta, 2) & "."
	if maxdiff > delta then wscript.echo "Skewed!" else wscript.echo "Smooth!"
end sub
