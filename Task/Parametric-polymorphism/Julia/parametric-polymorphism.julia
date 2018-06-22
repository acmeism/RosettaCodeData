mutable struct Tree{T}
    value::T
    lchild::Nullable{Tree{T}}
    rchild::Nullable{Tree{T}}
end

function replaceall!(t::Tree{T}, v::T) where T
    t.value = v
    isnull(lchild) || replaceall(get(lchild), v)
    isnull(rchild) || replaceall(get(rchild), v)
    return t
end
