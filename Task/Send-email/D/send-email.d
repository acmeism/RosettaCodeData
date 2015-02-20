void main() {
    import std.net.curl;

    auto s = SMTP("smtps://smtp.gmail.com");
    s.setAuthentication("someuser@gmail.com", "somepassword");
    s.mailTo = ["<friend@example.com>"];
    s.mailFrom = "<someuser@gmail.com>";
    s.message = "Subject:test\n\nExample Message";
    s.perform;
}
