list=.list~of('A','B','X')
say "Manual list traversal"
index=list~first
loop while index \== .nil
    say list~at(index)
    index = list~next(index)
end

say
say "Do ... Over traversal"
do value over list
    say value
end
