local http = require("socket.http")    -- Debian package is 'lua-socket'

function scrapeTime (pageAddress, timeZone)
    local page = http.request(pageAddress)
    if not page then return "Cannot connect" end
    for line in page:gmatch("[^<BR>]*") do
        if line:match(timeZone) then
            return line:match("%d+:%d+:%d+")
        end
    end
end

local url = "http://tycho.usno.navy.mil/cgi-bin/timer.pl"
print(scrapeTime(url, "UTC"))
