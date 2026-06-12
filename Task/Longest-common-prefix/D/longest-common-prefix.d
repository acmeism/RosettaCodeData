import std.stdio;

string lcp(string[] list ...) {
    string ret = "";
    int idx;

    while(true) {
        char thisLetter = 0;
        foreach (word; list) {
            if (idx == word.length) {
                return ret;
            }
            if(thisLetter == 0) { //if this is the first word then note the letter we are looking for
                thisLetter = word[idx];
            }
            if (thisLetter != word[idx]) { //if this word doesn't match the letter at this position we are done
                return ret;
            }
        }
        ret ~= thisLetter; //if we haven't said we are done then this position passed
        idx++;
    }
}

void main() {
    writeln(lcp("interspecies","interstellar","interstate"));
    writeln(lcp("throne","throne"));
    writeln(lcp("throne","dungeon"));
    writeln(lcp("throne","","throne"));
    writeln(lcp("cheese"));
    writeln(lcp(""));
    writeln(lcp("prefix","suffix"));
    writeln(lcp("foo","foobar"));
}
