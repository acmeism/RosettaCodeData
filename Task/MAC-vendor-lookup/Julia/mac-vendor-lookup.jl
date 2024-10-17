import HTTP: get

function getvendor(addr::String)
    try
        String(get("http://api.macvendors.com/$addr").body)
    catch e
        "Vendor not found"
    end
end

for addr in ["88:53:2E:67:07:BE", "FC:FB:FB:01:FA:21", "D4:F4:6F:C9:EF:8D", "23:45:67"]
    println("$addr -> ", getvendor(addr))
    sleep(0.5) # web site may error if requests are too close together
end
