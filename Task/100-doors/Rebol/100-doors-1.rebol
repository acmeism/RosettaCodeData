doors: array/initial 100 'closed
repeat i 100 [
    door: at doors i
    forskip door i [change door either 'open = first door ['closed] ['open]]
]
