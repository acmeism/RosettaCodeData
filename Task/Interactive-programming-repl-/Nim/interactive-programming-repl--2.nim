import ../compiler/[nimeval, llstream]

runRepl(llStreamOpenStdIn().repl, [findNimStdLibCompileTime()], true)
