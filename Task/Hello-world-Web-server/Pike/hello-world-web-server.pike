void handle_request(Protocols.HTTP.Server.Request request)
{
    request->response_and_finish( ([ "data":"Goodbye, World!",
                                     "type":"text/html" ]) );
}

int main()
{
    Protocols.HTTP.Server.Port(handle_request, 8080);
    return -1; // -1 is a special case that retirns control to the backend
}
