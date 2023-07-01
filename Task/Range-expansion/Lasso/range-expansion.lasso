define range_expand(expression::string) => {
    local(parts) = regexp(`^(-?\d+)-(-?\d+)$`)

    return (
        with elm in #expression->split(`,`)
        let isRange = #parts->setInput(#elm)&matches
        select #isRange
            ? (integer(#parts->matchString(1)) to integer(#parts->matchString(2)))->asString
            | integer(#elm)->asString
    )->join(', ')
}

range_expand(`-6,-3--1,3-5,7-11,14,15,17-20`)
