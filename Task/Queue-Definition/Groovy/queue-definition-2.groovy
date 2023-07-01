def q = new Queue()
assert q.empty

['Crosby', 'Stills'].each { q.push(it) }
assert !q.empty
['Nash', 'Young'].each { q.enqueue(it) }
println q
assert !q.empty
assert q.pop() == 'Crosby'
println q
assert !q.empty
assert q.dequeue() == 'Stills'
println q
assert !q.empty
assert q.pop() == 'Nash'
println q
assert !q.empty
q.push('Crazy Horse')
println q
assert q.dequeue() == 'Young'
println q
assert !q.empty
assert q.pop() == 'Crazy Horse'
println q
assert q.empty
try { q.pop() } catch (NoSuchElementException e) { println e }
try { q.dequeue() } catch (NoSuchElementException e) { println e }
