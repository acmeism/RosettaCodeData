:- system:set_prolog_flag(double_quotes,codes) .

:- [library(lists)] .

%!  starts_with(FIRSTz,SECONDz)
%
% True if `SECONDz` is the beginning of `FIRSTz` .

starts_with(FIRSTz,SECONDz)
:-
lists:append(SECONDz,_,FIRSTz)
.

%!  contains(FIRSTz,SECONDz)
%
% True once if `SECONDz` is contained within `FIRSTz` at one or more positions .

contains(FIRSTz,SECONDz)
:-
contains(FIRSTz,SECONDz,_) ,
!
.

%!  contains(FIRSTz,SECONDz,NTH1)
%
% True if `SECONDz` is contained within `FIRSTz` at position `NTH1` .

contains(FIRSTz,SECONDz,NTH1)
:-
lists:append([PREFIXz,SECONDz,_SUFFIXz_],FIRSTz) ,
prolog:length(PREFIXz,NTH0) ,
NTH1 is NTH0 + 1
.

%!  ends_with(FIRSTz,SECONDz)
%
% True if `SECONDz` is the ending of `FIRSTz` .

ends_with(FIRSTz,SECONDz)
:-
lists:append(_,SECONDz,FIRSTz)
.
