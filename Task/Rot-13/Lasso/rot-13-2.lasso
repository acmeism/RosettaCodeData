define rot13(p::string) => {
    local(
        rot13 = bytes,
        a = bytes('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'),
        b = bytes('NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm'),
        i
    )

    with char in #p->eachCharacter
    let c = bytes(#char) do {
        #i = #a->find(#b)
        #i ? #rot13->import8bits(#b->get(#i)) | #rot13->append(#c)
    }

    return #rot13->asString
}

rot13('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')
