URI uri;
try {
    uri = new URI("foo://example.com:8042/over/there?name=ferret#nose");
} catch (URISyntaxException exception) {
    /* invalid URI */
}
