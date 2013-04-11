module md5asm ;
import std.string ;
import std.conv ;
import std.math ;

version(D_InlineAsm_X86) {} else { static assert(0,"For X86 machine only") ; }

// ctfe construction of transform expressions
uint S(uint n) {
    return [7u,12,17,22,5,9,14,20,4,11,16,23,6,10,15,21][(n/16)*4 + (n % 4)] ;
}
uint K(uint n) {
    return ((n<=15)? n : (n <=31) ? 5*n+1 : (n<=47) ? (3*n+5) : (7*n)) % 16 ;
}
uint T(uint n) { return cast(uint) (abs(sin(n+1.0L))*(2UL^^32)) ; }
enum abcd = ["EAX", "EBX", "ECX", "EDX"] ;
string[] ABCD(int n) { return abcd[(64 - n)%4..4] ~ abcd[0..(64 - n)%4] ; }
string SUB(int n, string s) {
    return s.replace("ax", ABCD(n)[0]).replace("bx", ABCD(n)[1]).
             replace("cx", ABCD(n)[2]).replace("dx", ABCD(n)[3]) ;
}
// FF, GG, HH & II expressions part 1 (F,G,H,I)
string fghi1(int n) {
    switch(n / 16) {
        case 0: return // (bb & cc)|(~bb & dd)
            q{mov ESI,bx;mov EDI,bx;not ESI;and EDI,cx;and ESI,dx;or EDI,ESI;add ax,EDI;} ;
        case 1: return // (dd & bb)|(~dd & cc)
            q{mov ESI,dx;mov EDI,dx;not ESI;and EDI,bx;and ESI,cx;or EDI,ESI;add ax,EDI;} ;
        case 2: return // (bb ^ cc ^ dd)
            q{mov EDI,bx;xor EDI,cx;xor EDI,dx;add ax,EDI;} ;
        case 3: return // (cc ^ (bb | ~dd))
            q{mov EDI,dx;not EDI;or EDI,bx;xor EDI,cx;add ax,EDI;} ;
    }
}
// FF, GG, HH & II expressions part 2
string fghi2(int n) { return q{add ax,[EBP + 4*KK];add ax,TT;} ~ fghi1(n) ; }
// FF, GG, HH & II expressions prepended with previous parts & subsitute ABCD
string FGHI(int n) {
        return SUB(n, fghi2(n) ~ q{rol ax,SS;add ax,bx;}) ;
            // aa = ((aa << SS)|( aa >>> (32 - SS))) + bb = ROL(aa, SS) + bb
}
string EXPR(uint n) {
    return FGHI(n).replace("SS", to!string(S(n))).
                   replace("KK", to!string(K(n))).
                   replace("TT", "0x"~to!string(T(n),16)) ;
}
string TRANSFORM(int n) { return (n < 63) ? EXPR(n) ~ TRANSFORM(n+1) : EXPR(n) ; }

// main steps of transform , to be mixing
const string Transform = TRANSFORM(0) ;
