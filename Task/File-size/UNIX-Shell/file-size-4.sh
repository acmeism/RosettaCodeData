# from module 'zsh/stat', load builtin 'zstat'
zmodload -F zsh/stat b:zstat

size1=$(zstat +size input.txt)
size2=$(zstat +size /input.txt)
