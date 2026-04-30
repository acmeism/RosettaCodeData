remove-comments: func[line sep][
    parse line [to sep remove to end]
    trim/tail line
]

probe remove-comments "apples ; pears # and bananas" charset ";#"
probe remove-comments "apples ; pears # and bananas" #";"
probe remove-comments "apples ; pears # and bananas" #"#"
probe remove-comments "apples ; pears # and bananas" #"!"
