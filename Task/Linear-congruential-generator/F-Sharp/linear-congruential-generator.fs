module lcg =
    let bsd seed =
        let state = ref seed
        (fun (_:unit) ->
            state := (1103515245 * !state + 12345) &&& System.Int32.MaxValue
            !state)

    let ms seed =
        let state = ref seed
        (fun (_:unit) ->
            state := (214013 * !state + 2531011) &&& System.Int32.MaxValue
            !state / (1<<<16))
