revstr :: String -> String
revstr = unwords . reverse . words -- point-free style
--equivalent:
--revstr s = unwords (reverse (words s))

revtext :: String -> String
revtext = unlines . map revstr . lines -- applies revstr to each line independently

test = revtext "---------- Ice and Fire ------------\n\
        \\n\
        \fire, in end will world the say Some\n\
        \ice. in say Some\n\
        \desire of tasted I've what From\n\
        \fire. favor who those with hold I\n\
        \\n\
        \... elided paragraph last ...\n\
        \\n\
        \Frost Robert -----------------------\n" --multiline string notation requires \ at end and start of lines, and \n to be manually input
