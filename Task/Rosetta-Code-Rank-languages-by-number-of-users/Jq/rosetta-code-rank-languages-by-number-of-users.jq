def rpad($len): tostring | ($len - length) as $l | . + (" " * $l);

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def cat: sub("Category:";"") | sub(" User$";"");

"As of \(now | strftime("%A %B %d, %Y %Z %H:%M") ):",
"\n\("Language" | rpad(30)) Users",
"_" * 36,
([.query.pages[] | {title, n: .categoryinfo.size}]
 | sort_by(.n)
 | reverse[]
 | select(.n>100)
 | "\(.title | cat | rpad(30)) \(.n|lpad(5))" )
