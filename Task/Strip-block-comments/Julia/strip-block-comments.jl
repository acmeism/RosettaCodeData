function _stripcomments(txt::AbstractString, dlm::Tuple{String,String})
    "Strips first nest of block comments"

    dlml, dlmr = dlm
    indx = searchindex(txt, dlml)
    if indx > 0
        out = IOBuffer()
        write(out, txt[1:indx-1])
        txt = txt[indx+length(dlml):end]
        txt = _stripcomments(txt, dlm)
        indx = searchindex(txt, dlmr)
        @assert(indx > 0, "cannot find a closer delimiter \"$dlmr\" in $txt")
        write(out, txt[indx+length(dlmr):end])
    else
        out = txt
    end
    return String(out)
end

function stripcomments(txt::AbstractString, dlm::Tuple{String,String}=("/*", "*/"))
    "Strips nests of block comments"

    dlml, dlmr = dlm
    while contains(txt, dlml)
        txt = _stripcomments(txt, dlm)
    end

    return txt
end

function main()
    println("\nNON-NESTED BLOCK COMMENT EXAMPLE:")
    smpl = """
/**
* Some comments
* longer comments here that we can parse.
*
* Rahoo
*/
function subroutine() {
a = /* inline comment */ b + c ;
}
/*/ <-- tricky comments */

/**
* Another comment.
*/
function something() {
}
"""
    println(stripcomments(smpl))

    println("\nNESTED BLOCK COMMENT EXAMPLE:")
    smpl = """
/**
* Some comments
* longer comments here that we can parse.
*
* Rahoo
*//*
function subroutine() {
a = /* inline comment */ b + c ;
}
/*/ <-- tricky comments */
*/
/**
* Another comment.
*/
function something() {
}
"""
    println(stripcomments(smpl))
end

main()
