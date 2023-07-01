def funcMaker = { String s, int reps, boolean caps ->
    caps ? { String transString -> ((transString + s) * reps).toUpperCase() }
         : { String transString -> (transString + s) * reps }
}
def func = funcMaker("a", 2, true)
assert func("pook") == "POOKAPOOKA"
