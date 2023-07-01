import osproc

let exitCode = execCmd "ls"
let (output, exitCode2) = execCmdEx "ls"
