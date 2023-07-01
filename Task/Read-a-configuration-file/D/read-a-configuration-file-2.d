import std.stdio, std.string, std.conv, std.regex, std.algorithm;

auto reNameValue = ctRegex!(`^(\w+)\s*=?\s*(\S.*)?`);// ctRegex creates regexp parser at compile time

// print Config members w/o hardcoding names
void PrintMembers(Config c)
{
    foreach(M; __traits(derivedMembers, Config))
        writeln(M ~ ` = `, __traits(getMember, c, M));
}

void main(in string[] args /* arg[0] is EXE name */) {

    auto cfg = new Config;
    auto f = args[1].File;// open config given in command line
    foreach (line; f.byLineCopy.map!(s => s.strip).filter!(s => !s.empty && s[0] != '#' && s[0] != ';')) {// free loop from unnecessary lines
        auto m = matchFirst(line, reNameValue);
        if (m.empty) { writeln(`Wrong config line: ` ~ line); continue; }

        switch(m[1].toUpper) {
        case `FULLNAME`:       cfg.FullName       = m[2]; break;
        case `FAVOURITEFRUIT`: cfg.FavouriteFruit = m[2]; break;
        case `NEEDSPEELING`:   cfg.needsPeeling   = (m[2].toUpper != `FALSE`); break;
        case `SEEDSREMOVED`:   cfg.seedsRemoved   = (m[2].toUpper != `FALSE`); break;
        case `OTHERFAMILY`:    cfg.otherFamily    = split(m[2], regex(`\s*,\s*`)); break;// regex allows to avoid 'strip' step
        default:
            writeln(`Unknown config variable: ` ~ m[1]);
        }
    }
    PrintMembers(cfg);
}

class Config
{
    string FullName;
    string FavouriteFruit;
    bool needsPeeling;
    bool seedsRemoved;
    string[] otherFamily;
}
