"""
From perl code at https://github.com/trapd00r/vidir/blob/master/bin/vidir

# vidir - edit directory

# Synopsis: vidir [--verbose] [directory|file|-] ...

# Description:
# vidir allows editing of the contents of a directory in a text editor. If no
# directory is specified, the current directory is edited.
#
# When editing a directory, each item in the directory will appear on its own
# numbered line. These numbers are how vidir keeps track of what items are
# changed. Delete lines to remove files from the directory, or
# edit filenames to rename files. You can also switch pairs of numbers to
# swap filenames.
#
# Note that if "-" is specified as the directory to edit, it reads a list of
# filenames from stdin and displays those for editing. Alternatively, a list
# of files can be specified on the command line.
"""

using ArgParse

const DEBUG = false

""" process command line arguments """
function parse_args2()
    s = ArgParseSettings()
    add_arg_table!(s,
        ["--verbose", "-v"],
        Dict(:help => "Verbosely display the actions taken by the program",
             :action => :store_true),
        "items",
        Dict(
            :help => "Directory, file, or - for stdin",
            :nargs => '*',
            :default => ["."])
    )
    return parse_args(ARGS, s)
end

""" vidir function, from Unix routine. See also documentation above """
function vidir()
    args = parse_args2()
    verbose = args["verbose"]  || DEBUG
    items = args["items"]
    error_occurred = false

    # Collect directory items
    dir = String[]
    for item in items
        if item == "-"
            append!(dir, readlines(stdin))
            # Reopen stdin to terminal
            try
                freopen("/dev/tty", "r", stdin)
            catch e
                error("Cannot reopen stdin: $e")
            end
        elseif isdir(item)
            item = rstrip(item, '/') * "/"
            try
                append!(dir, [item * f for f in sort(readdir(item))])
            catch e
                error("Cannot read $item: $e")
            end
        else
            push!(dir, item)
        end
    end

    # Check for control characters
    if any(x -> occursin(r"[[:cntrl:]]", x), dir)
        error("Control characters in filenames are not supported")
    end

    # Create temporary file
    tmp = tempname()
    open(tmp, "w") do out
        item_dict = Dict{Int,String}()
        c = 0
        for item in dir
            if !occursin(r"^(.*\/)?\.$|^(.*\/)?\.\.$", item)
                c += 1
                item_dict[c] = item
                println(out, "$c\t$item")
            end
        end
        flush(out)

        # Choose editor
        editor = ["vi"]
        if isfile("/usr/bin/editor")
            editor = ["/usr/bin/editor"]
        end
        if haskey(ENV, "EDITOR")
            editor = split(ENV["EDITOR"])
        end
        if haskey(ENV, "VISUAL")
            editor = split(ENV["VISUAL"])
        end

        # Run editor
        ret = run(`$editor $tmp`, wait=true)
        if !success(ret)
            error("$editor exited nonzero, aborting")
        end

        # Process edited file
        open(tmp, "r") do input
            for line in eachline(input)
                if isempty(strip(line))
                    continue
                end
                m = match(r"^(\d+)\t{0,1}(.*)", line)
                if isnothing(m)
                    error("Unable to parse line \"$line\", aborting")
                end
                num = parse(Int, m[1])
                name = m[2]
                if !haskey(item_dict, num)
                    error("Unknown item number $num")
                elseif name != item_dict[num]
                    if !isempty(name)
                        src = item_dict[num]

                        if !isfile(src) && !islink(src)
                            println(stderr, "vidir: $src does not exist")
                            delete!(item_dict, num)
                            continue
                        end

                        # Handle swaps
                        if isfile(name) || islink(name)
                            tmp_name = name * "~"
                            c = 0
                            while isfile(tmp_name) || islink(tmp_name)
                                c += 1
                                tmp_name = name * "~$c"
                            end
                            try
                                mv(name, tmp_name)
                                verbose && println("'$name' -> '$tmp_name'")
                                for (k, v) in item_dict
                                    if v == name
                                        item_dict[k] = tmp_name
                                    end
                                end
                            catch e
                                @warn "vidir: failed to rename $name to $tmp_name: $e"
                                error_occurred = true
                            end
                        end

                        try
                            mv(src, name)
                            if isdir(name)
                                for (k, v) in item_dict
                                    item_dict[k] = replace(v, Regex("^$src") => name)
                                end
                            end
                            verbose && println("'$src' => '$name'")
                        catch e
                            @warn "vidir: failed to rename $src to $name: $e"
                            error_occurred = true
                        end
                    end
                end
                delete!(item_dict, num)
            end
        end


        # Clean up temporary files
        isfile(tmp * "~") && rm(tmp * "~")

        # Remove remaining items
        for item in sort(collect(values(item_dict)), rev=true)
            try
                if isdir(item) && !islink(item)
                    rmdir(item)
                else
                    rm(item)
                end
                verbose && println("removed '$item'")
            catch e
                @warn "vidir: failed to remove $item: $e"
                error_occurred = true
            end
        end
    end
    return error_occurred
end

""" run main """
vidir()
