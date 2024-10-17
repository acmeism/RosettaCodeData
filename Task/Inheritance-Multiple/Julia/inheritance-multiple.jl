abstract type Phone end

struct DeskPhone <: Phone
    book::Dict{String,String}
end

abstract type Camera end

struct kodak
    roll::Vector{Array{Int32,2}}
end

struct CellPhone <: Phone
    book::Dict{String,String}
    roll::Vector{AbstractVector}
end

function dialnumber(phone::CellPhone)
    println("beep beep")
end

function dialnumber(phone::Phone)
    println("tat tat tat tat")
end

function snap(camera, img)
    println("click")
    push!(camera.roll, img)
end

dphone = DeskPhone(Dict(["information" => "411"]))
cphone = CellPhone(Dict(["emergency" => "911"]), [[]])

dialnumber(dphone)
dialnumber(cphone)
