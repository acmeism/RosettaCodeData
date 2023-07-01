define printTimesTables(max::integer) => {
    local(result)  = ``
    local(padSize) = string(#max*#max)->size + 1

    // Print header row
    #result->append((' ' * #padSize) + '|')
    loop(#max) => {
        #result->append(loop_count->asString(-padding=#padSize))
    }
    #result->append("\n" + (`-` * #padSize) + '+' + (`-` * (#padSize * #max)))

    with left in 1 to #max do {
        // left column
        #result->append("\n" + #left->asString(-padding=#padSize) + '|')

        // Table results
        with right in 1 to #max do {
            #result->append(
                #right < #left
                    ? ' ' * #padSize
                    | (#left * #right)->asString(-padding=#padSize)
            )
        }
    }

    return #result
}

printTimesTables(12)
