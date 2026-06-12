import std.algorithm;
import std.net.curl;
import std.range;
import std.regex;
import std.stdio;
import std.string;

void process(string base, string task) {
    auto re2 = ctRegex!`</?[^>]*>`;

    auto page = base ~ task;
    auto content = get(page);

    string prefix = `using any language you may know.</div>`;
    auto beg = content.indexOf(prefix);
    auto end = content.indexOf(`<div id="toc"`, beg);
    auto snippet = content[beg + prefix.length .. end];
    writeln(replaceAll(snippet, re2, ``));

    writeln("#####################################################");
}

void main() {
    auto pattern = ctRegex!`<li><a href="/wiki/(.*?)"`;

    auto content = get("http://rosettacode.org/wiki/Category:Programming_Tasks");

    string[] tasks;
    foreach (m; matchAll(content, pattern)) {
        tasks ~= m[1].idup;
    }

    auto base = "http://rosettacode.org/wiki/";
    tasks.take(3).each!(task => process(base, task));
}
