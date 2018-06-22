function quibble(arr::Array)
    if isempty(arr) rst = "" else rst = "$(arr[end])" end
    if length(arr) > 1 rst = join(arr[1:end-1], ", ") * " and " * rst end
    return "{" * rst * "}"
end

@show quibble([])
@show quibble(["ABC"])
@show quibble(["ABC", "DEF"])
@show quibble(["ABC", "DEF", "G", "H"])
