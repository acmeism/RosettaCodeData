using Base64, HTTP, JSON2, Sockets, SQLite, SHA

function processpost(req::HTTP.Request, urilen=8)
    json = JSON2.read(String(HTTP.payload(req)))
    if haskey(json, :long)
        longname = json.long
        encoded, shortname = [UInt8(c) for c in base64encode(sha256(longname))], ""
        for i in 0:length(encoded)-1
            shortname = String(circshift(encoded, i)[1:urilen])
            result = SQLite.Query(dbhandle,
                "SELECT LONG FROM LONGNAMESHORTNAME WHERE SHORT = \"" * shortname * "\";")
            if isempty(result)
                SQLite.Query(dbhandle,
                    "INSERT INTO LONGNAMESHORTNAME VALUES ('" *
                        longname *  "', '" * shortname * "')")
                return HTTP.Response(200, JSON2.write(
                    "$shortname is short name for $longname."))
            end
        end
    end
    HTTP.Response(400, JSON2.write("Bad request. Please POST JSON as { long : longname }"))
end

function processget(req::HTTP.Request)
    shortname = split(req.target, r"[^\w\d\+\\]+")[end]
    result = SQLite.Query(dbhandle, "SELECT LONG FROM LONGNAMESHORTNAME WHERE SHORT = \'" *
            shortname * "\' ;")
    responsebody = isempty(result) ?
        "<!DOCTYPE html><html><head></head><body><h2>Not Found</h2></body></html>" :
        "<!DOCTYPE html><html><head></head><body>\n<meta http-equiv=\"refresh\"" *
        "content = \"0; url = " * first(result).LONG * " /></body></html>"
    return HTTP.Response(200, responsebody)
end

function run_web_server(server, portnum)
    router = HTTP.Router()
    HTTP.@register(router, "POST", "", processpost)
    HTTP.@register(router, "GET", "/*", processget)
    HTTP.serve(router, server, portnum)
end

const dbhandle = SQLite.DB("longshort.db")
const serveraddress = Sockets.localhost
const localport = 3000
run_web_server(serveraddress, localport)
