const filename = "traceback.txt"
const pmarker, target = "Traceback (most recent call last):", "SystemError"

foreach(
    p -> println(p, p[end] == '\n' ? "" : "\n", "-"^16),
    [
        p[findfirst(pmarker, p).start:end] for
        p in split(read(filename, String), r"\r?\n\r?\n") if
        contains(p, pmarker) && contains(p, target)
    ],
)
