make-acc-gen: func [start-val] [
    use [state] [
        state: start-val
        func [value] [
            state: state + value
        ]
    ]
]
gen: make-acc-gen 1
print gen 5   ;== 6
print gen 2.3 ;== 8.3
