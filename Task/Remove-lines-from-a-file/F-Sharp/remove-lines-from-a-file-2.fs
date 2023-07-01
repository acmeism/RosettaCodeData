D:\Projects\Rosetta>for /l %i in (1,1,5) do @echo %i >> foo

D:\Projects\Rosetta>Remove_lines_from_a_file.exe foo 1 2

D:\Projects\Rosetta>type foo
3
4
5

D:\Projects\Rosetta>
