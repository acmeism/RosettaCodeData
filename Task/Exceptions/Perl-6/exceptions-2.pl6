sub f(){
        ENTER { note '1) f has been entered' }
        LEAVE { note '2) f has been left' }
        say '3) here be dragons';
        die '4) that happend to be deadly';
}

f();
say '5) am I alive?';

CATCH {
        when X::AdHoc { note q{6) no, I'm dead}; }
}
