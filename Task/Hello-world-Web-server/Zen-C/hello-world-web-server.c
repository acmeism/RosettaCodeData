import "std/net/http.zc"

// The handler receives a pointer to the Request and Response objects
fn handler(_req: Request*, res: Response*) {
    res.set_body_str("Goodbye, World!");
}

fn main() {
    // Create a new HTTP server on port 8080 routing to the handler
    let server = Server::new(8080, handler);
    println "Serving 'Goodbye, World!' at http://localhost:8080/";

    // Start listening for incoming connections
    server.start();
}
