using StaticCompiler, StaticTools

hello() = println(c"Hello world!") # the c"" syntax defines a static C type string
compile_executable(hello, (), "./") # can now run this as executable "hello"
