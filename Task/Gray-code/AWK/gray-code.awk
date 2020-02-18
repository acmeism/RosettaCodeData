# Tested using GAWK

function bits2str(bits,        data, mask)
{
    # Source: https://www.gnu.org/software/gawk/manual/html_node/Bitwise-Functions.html
    if (bits == 0)
        return "0"

    mask = 1
    for (; bits != 0; bits = rshift(bits, 1))
        data = (and(bits, mask) ? "1" : "0") data

    while ((length(data) % 8) != 0)
        data = "0" data

    return data
}

function gray_encode(n){
    # Source: https://en.wikipedia.org/wiki/Gray_code#Converting_to_and_from_Gray_code
    return xor(n,rshift(n,1))
}

function gray_decode(n){
    # Source: https://en.wikipedia.org/wiki/Gray_code#Converting_to_and_from_Gray_code
    mask = rshift(n,1)
    while(mask != 0){
        n = xor(n,mask)
        mask = rshift(mask,1)
    }
    return n
}

BEGIN{
    for (i=0; i < 32; i++)
        printf "%-3s => %05d => %05d => %05d\n",i, bits2str(i),bits2str(gray_encode(i)), bits2str(gray_decode(gray_encode(i)))
}
