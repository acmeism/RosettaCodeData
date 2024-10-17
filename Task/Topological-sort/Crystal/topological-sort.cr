def dfs_topo_visit(n, g, tmp, permanent, l)
    if permanent.includes?(n)
        return
    elsif tmp.includes?(n)
        raise "unorderable: circular dependency detected involving '#{n}'"
    end
    tmp.add(n)

    g[n].each { |m|
        dfs_topo_visit(m, g, tmp, permanent, l)
    }

    tmp.delete(n)
    permanent.add(n)
    l.insert(0, n)
end


def dfs_topo_sort(g)
    tmp = Set(String).new
    permanent = Set(String).new
    l = Array(String).new

    while true
        keys = g.keys.to_set - permanent
        if keys.empty?
            break
        end

        n = keys.first
        dfs_topo_visit(n, g, tmp, permanent, l)
    end

    return l
end


def build_graph(deps)
    g = {} of String => Set(String)
    deps.split("\n").each { |line|
        line_split = line.strip.split
        line_split.each { |dep|
            unless g.has_key?(dep)
                g[dep] = Set(String).new
            end
            unless line_split[0] == dep
                g[dep].add(line_split[0])
            end
        }
    }
    return g
end


data = "des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee
dw01             ieee dw01 dware gtech
dw02             ieee dw02 dware
dw03             std synopsys dware dw03 dw02 dw01 ieee gtech
dw04             dw04 ieee dw01 dware gtech
dw05             dw05 ieee dware
dw06             dw06 ieee dware
dw07             ieee dware
dware            ieee dware
gtech            ieee gtech
ramlib           std ieee
std_cell_lib     ieee std_cell_lib
synopsys"

circular_deps = "\ncyc01             cyc02
                   cyc02             cyc01"

puts dfs_topo_sort(build_graph(data)).join(" -> ")
puts ""
puts dfs_topo_sort(build_graph(data + circular_deps)).join(" -> ")
