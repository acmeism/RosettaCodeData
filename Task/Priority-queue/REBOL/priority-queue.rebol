Rebol [
    title: "Rosetta code: Priority queue"
    file:  %Priority_queue.r3
    url:   https://rosettacode.org/wiki/Priority_queue
]

priority-que: context [
    ;- private values -;
    que: []                           ;; internal sorted queue (ascending priority)
    protect/hide 'que

    ;- public api -;
    task!: make struct! [
        priority [uint32!]
        name     [rebval!]
    ]
    put: func [
        task [block!]
    ][
        task: make task! task
        unless foreach [here: qued] que [ ;; scan for insertion point
            if task/priority <= qued/priority [
                insert here task      ;; insert before first higher-priority item
                break/return true
            ]
        ][
            append que task           ;; no insertion point found; append at end
        ]
    ]
    pop: does [ take que ]            ;; remove and return first (lowest priority)
]

foreach task [
    [3 "Clear drains"  ]
    [4 "Feed cat"      ]
    [5 "Make tea"      ]
    [1 "Solve RC tasks"]
    [2 "Tax retur"     ]
][
    print ["Add:" mold task]
    priority-que/put task
]

print ""
while [task: priority-que/pop][
    print ["Pop:" mold values-of task]
]
