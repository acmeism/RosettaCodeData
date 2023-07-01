Red []

clicks: 0

view [
    t: text "There have been no clicks yet" return
    button "click me" [
        clicks: clicks + 1
        t/data: rejoin ["clicks: " clicks]
    ]
]
