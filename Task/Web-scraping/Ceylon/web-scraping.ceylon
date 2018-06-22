import ceylon.uri {
    parse
}
import ceylon.http.client {
    get
}

shared void run() {

    // apparently the cgi link is deprecated?
    value oldUri = "http://tycho.usno.navy.mil/cgi-bin/timer.pl";
    value newUri = "http://tycho.usno.navy.mil/timer.pl";

    value contents = downloadContents(newUri);
    value time = extractTime(contents);
    print(time else "nothing found");
}

String downloadContents(String uriString) {
    value uri = parse(uriString);
    value request = get(uri);
    value response = request.execute();
    return response.contents;
}

String? extractTime(String contents) =>
        contents
        .lines
        .filter((String element) => element.contains("UTC"))
        .first
        ?.substring(4, 21);
