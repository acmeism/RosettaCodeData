function main()
    lastidle = lasttotal = 0
    while true
        ln = readline("/proc/stat")
        fields = parse.(Float64, split(ln)[2:end])
        idle, total = fields[4], sum(fields)
        Δidle, Δtotal = idle - lastidle, total - lasttotal
        lastidle, lasttotal = idle, total
        utilization = 100 * (1 - Δidle / Δtotal)
        @printf "%5.1f%%\r" utilization
        sleep(5)
    end
end

main()
