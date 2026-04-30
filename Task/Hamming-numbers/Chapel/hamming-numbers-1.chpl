use BigInteger; use Time;

// Chapel doesn't have closure functions that can capture variables from
// outside scope, so we use a class to emulate them for this special case;
// the member fields mult, mrglst, and mltlst, emulate "captured" variables
// that would normally be captured by the `next` continuation closure...
class HammingsList {
    const head: bigint;
    const mult: uint(8);
    var mrglst: shared HammingsList?;
    var mltlst: shared HammingsList?;
    var tail: shared HammingsList? = nil;
    proc init(hd: bigint, mlt: uint(8), mrgl: shared HammingsList?,
                                        mltl: shared HammingsList?) {
        head = hd; mult = mlt; mrglst = mrgl; mltlst = mltl; }
    proc next(): shared HammingsList {
        if tail != nil then return tail: shared HammingsList;
        const nhd: bigint = mltlst!.head * mult;
        if mrglst == nil then {
            tail = new shared HammingsList(nhd, mult,
                                           nil: shared HammingsList?,
                                           nil: shared HammingsList?);
            mltlst = mltlst!.next();
            tail!.mltlst <=> mltlst;
        }
        else {
            if mrglst!.head < nhd then {
                tail = new shared HammingsList(mrglst!.head, mult,
                                               nil: shared HammingsList?,
                                               nil: shared HammingsList?);
                mrglst = mrglst!.next(); mrglst <=> tail!.mrglst;
                mltlst <=> tail!.mltlst;
            }
            else {
                tail = new shared HammingsList(nhd, mult,
                                               nil: shared HammingsList?,
                                               nil: shared HammingsList?);
                mltlst = mltlst!.next(); mltlst <=> tail!.mltlst;
                mrglst <=> tail!.mrglst;
            }
        }
        return tail: shared HammingsList;
    }
}

proc u(n: uint(8), s: shared HammingsList?): shared HammingsList {
    var r = new shared HammingsList(1: bigint, n, s,
                                    nil: shared HammingsList?);
    r.mltlst = r; // lazy recursion!
    return r.next();
}

iter hammings(): bigint {
    var nxt: shared HammingsList? = nil: shared HammingsList?;
    const mlts: [ 0 .. 2 ] int = [ 5, 3, 2 ];
    for m in mlts do nxt = u(m: uint(8), nxt);
    yield 1 : bigint;
    while true { yield nxt!.head; nxt = nxt!.next(); }
}

write("The first 20 Hamming numbers are: ");
var cnt: int = 0;
for h in hammings() { write(" ", h); cnt += 1; if cnt >= 20 then break; }
write(".\nThe 1691st Hamming number is ");
cnt = 0;
for h in hammings() { cnt += 1; if cnt < 1691 then continue; write(h); break; }
writeln(".\nThe millionth Hamming number is ");
var timer: Timer; timer.start(); cnt = 0;
for h in hammings() { cnt += 1; if cnt < 1000000 then continue; write(h); break; }
timer.stop(); writeln(".\nThis last took ",
                      timer.elapsed(TimeUnits.milliseconds), " milliseconds.");
