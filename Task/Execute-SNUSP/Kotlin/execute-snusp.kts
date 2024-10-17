// version 1.1.2

// requires 5 chars (10 bytes) of data store
const val hw = """
/++++!/===========?\>++.>+.+++++++..+++\
\+++\ | /+>+++++++>/ /++++++++++<<.++>./
$+++/ | \+++++++++>\ \+++++.>.+++.-----\
      \==-<<<<+>+++/ /=.>.+>.--------.-/"""

// input is a multi-line string.
fun snusp(dlen: Int, raw: String) {
    val ds = CharArray(dlen)  // data store
    var dp = 0                // data pointer
    var s = raw

    // remove leading '\n' from string if present
    s = s.trimStart('\n')

    // make 2 dimensional instruction store and declare instruction pointers
    val cs = s.split('\n')
    var ipr = 0
    var ipc = 0

    // look for starting instruction
    findStart@  for ((r, row) in cs.withIndex()) {
        for ((i, c) in row.withIndex()) {
            if (c == '$') {
                ipr = r
                ipc = i
                break@findStart
            }
        }
    }

    var id = 0
    val step = fun() {
        if (id and 1 == 0)
            ipc += 1 - (id and 2)
        else
            ipr += 1 - (id and 2)
    }

    // execute
    while ((ipr in 0 until cs.size) && (ipc in 0 until cs[ipr].length)) {
        when (cs[ipr][ipc]) {
            '>'  -> dp++
            '<'  -> dp--
            '+'  -> ds[dp]++
            '-'  -> ds[dp]--
            '.'  -> print(ds[dp])
            ','  -> ds[dp] = readLine()!![0]
            '/'  -> id = id.inv()
            '\\' -> id = id xor 1
            '!'  -> step()
            '?'  -> if (ds[dp] == '\u0000') step()
        }
        step()
    }
}

fun main(args: Array<String>) {
    snusp(5, hw)
}
