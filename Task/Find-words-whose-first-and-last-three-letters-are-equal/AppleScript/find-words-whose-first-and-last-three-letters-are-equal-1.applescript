on task()
    script o
        property wrds : words of ¬
            (read file ((path to desktop as text) & "www.rosettacode.org:unixdict.txt") as «class utf8»)
        property output : {}
    end script

    repeat with thisWord in o's wrds
        if ((thisWord's length > 5) and (thisWord ends with thisWord's text 1 thru 3)) then ¬
            set end of o's output to thisWord
    end repeat

    return o's output's contents
end task

task()
