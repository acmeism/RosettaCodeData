using HTTP, HTTP.IOExtras, JSON, MusicProcessing
HTTP.open("POST", "http://music.com/play") do io
    write(io, JSON.json([
        "auth" => "12345XXXX",
        "song_id" => 7,
    ]))
    r = startread(io)
    @show r.status
    while !eof(io)
        bytes = readavailable(io)
        play(bytes)
    end
end
