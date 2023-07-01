; Use 'repeat' when an index required, 'loop' when repetition suffices:

repeat i 5 [
	loop i [prin "*"]
	print ""
]

; or a more traditional for loop:

for i 1 5 1 [
	loop i [prin "*"]
	print ""
]
