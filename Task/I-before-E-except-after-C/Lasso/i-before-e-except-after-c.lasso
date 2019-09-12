local(cie,cei,ie,ei) = (:0,0,0,0)

local(match_ie) = regExp(`[^c]ie`)
local(match_ei) = regExp(`[^c]ei`)

with word in include_url(`http://wiki.puzzlers.org/pub/wordlists/unixdict.txt`)->asString->split("\n")
where #word >> `ie` or #word >> `ei`
do {
    #word >> `cie`
        ? #cie++
    #word >> `cei`
        ? #cei++

    #match_ie->reset(-input=#word, -ignoreCase)&find
        ? #ie++
    #match_ei->reset(-input=#word, -ignoreCase)&find
        ? #ei++
}

local(ie_plausible)  = (#ie  >= (2 * #ei))
local(cei_plausible) = (#cei >= (2 * #cie))

stdoutnl(
    `The rule "I before E when not preceded by C" is ` +
    (#ie_plausible ? '' | 'NOT-') + `PLAUSIBLE. There were ` +
    #ie + ` examples and ` + #ei + ` counter-examples.`
)
stdoutnl(
    `The rule "E before I when preceded by C" is ` +
    (#cei_plausible ? `` | `NOT-`) + `PLAUSIBLE. There were ` +
    #cei + ` examples and ` + #cie + ` counter-examples.`
)
stdoutnl(`Overall the rule is ` + (#ie_plausible and #cei_plausible ? `` | `NOT-`) + `PLAUSIBLE`)
