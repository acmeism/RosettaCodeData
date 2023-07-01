make-acc-gen: func [start-val] [
    use [state] [
        state: start-val
        func [value] [
            state: state + value
        ]
    ]
]
