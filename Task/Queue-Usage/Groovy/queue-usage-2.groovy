assert q.empty
println q
// "push" adds to end of "queue" list
q.push('Stuart')
println q
assert !q.empty
// "add" adds to end of "queue" list
q.add('Pete')
println q
assert !q.empty
// left shift operator ("<<") adds to end of "queue" list
q << 'John'
println q
assert !q.empty
// add assignment ("+=") adds the list elements
// to the end of the "queue" list in list order
q += ['Paul', 'George']
println q
assert !q.empty
// "poll" removes and returns the first element in the
// "queue" list ("pop" exists for Groovy lists, but it
// removes and returns the LAST element for "Stack"
// semantics). "poll" only exists in objects that
// implement java.util.Queue, like java.util.LinkedList
assert q.poll() == 'Stuart'
println q
assert !q.empty
assert q.poll() == 'Pete'
println q
assert !q.empty
q << 'Ringo'
println q
assert !q.empty
assert q.poll() == 'John'
println q
assert !q.empty
assert q.poll() == 'Paul'
println q
assert !q.empty
assert q.poll() == 'George'
println q
assert !q.empty
assert q.poll() == 'Ringo'
println q
assert q.empty
assert q.poll() == null
