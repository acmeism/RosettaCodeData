Rebol [
    title: "Rosetta code: Hello world/Web server"
    file:  %Hello_world-Web_server.r3
    url:   https://rosettacode.org/wiki/Hello_world-Web_server
    needs: httpd ;; see: https://github.com/Oldes/Rebol-httpd
]

serve-http [port: 8080 actor: [
    On-Get: func [ctx][
        either ctx/inp/target/file = %/ [
            ;; Respond if the url was http://localhost:8080/
            ctx/out/content: "Goodbye, World!"
        ][
            ;; Else respond with an error.
            ctx/out/status: 418 ;= I'm a teapot
        ]
    ]
    On-Post: func[ctx][
        ;; responding with a parsed content; including a custom message in the header...
        ctx/out/header/X-Response: "Just a custom message in the header."
        ctx/out/content: mold ctx/inp/content
    ]
]]
