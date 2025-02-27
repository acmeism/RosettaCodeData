Red []

arg: system/script/args

if arg = "" [
    print "Missing command line argument for language"
    quit/return 1
]

lang: trim/with arg #"'"

getall: func[category [string!] /local titles cmcontinue page][
    titles: make block! 500
    cmcontinue: none
    forever [
        page: load-json read rejoin [
            http://rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:
            enhex category
            "&format=json&cmlimit=500"
            either cmcontinue = none [""] [rejoin ["&cmcontinue=" enhex cmcontinue]]
        ]
        foreach member page/query/categorymembers [
            append titles member/title
        ]
        if page/continue = none [break/return titles]
        cmcontinue: page/continue/cmcontinue
    ]
]

lang-tasks: getall lang
programming-tasks: getall "Programming_Tasks"

foreach task sort exclude programming-tasks lang-tasks [
    print task
]
