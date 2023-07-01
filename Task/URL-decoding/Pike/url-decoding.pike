void main()
{
    array encoded_urls = ({
        "http%3A%2F%2Ffoo%20bar%2F",
        "google.com/search?q=%60Abdu%27l-Bah%C3%A1"
    });


    foreach(encoded_urls, string url) {
        string decoded = Protocols.HTTP.uri_decode( url );
        write( string_to_utf8(decoded) +"\n" ); // Assume sink does UTF8
    }
}
