10 [ 10000 random ] replicate
[ "Before:  " write . ]
[ "Natural: " write [ natural-sort! ] keep . ]
[ "Reverse: " write [ [ >=< ] sort! ] keep . ] tri
