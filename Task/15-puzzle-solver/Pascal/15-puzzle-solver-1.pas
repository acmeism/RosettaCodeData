unit FifteenSolverT;
\\ Solve 15 Puzzle. Nigel Galloway; February 1st., 2019.
interface
type TN=record n:UInt64; i,g,e,l:shortint; end;
type TG=record found:boolean; path:array[0..99] of TN; end;
function solve15(const board : UInt64; const bPos:shortint; const d:shortint; const ng:shortint):TG;
const endPos:UInt64=$123456789abcdef0;
implementation
const N:array[0..15] of shortint=(3,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3);
const I:array[0..15] of shortint=(3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2);
const G:array[0..15] of shortint=(5,13,13,9,7,15,15,11,7,15,15,11,6,14,14,10);
const E:array[0..15] of shortint=(0,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4);
const L:array[0..4 ] of shortint=(0,11,19,14,16);
function solve15(const board:UInt64; const bPos:shortint; const d:shortint; const ng:shortint):TG;
var path:TG; P:^TN; Q:^TN; _g:shortint; _n:UInt64;
begin P:=@path.path; P^.n:=board; P^.i:=0; P^.g:=0; P^.e:=ng; P^.l:=bPos;
  while true do begin
    if P<@path.path then begin path.found:=false; exit(path); end;
    if P^.n=endPos  then begin path.found:=true; exit(path); end;
    if (P^.e=0) or (P^.i>d) then begin P-=1; continue; end else begin Q:=P+1; Q^.g:=E[P^.e]; end;
    Q^.i:=P^.i; _g:=(L[Q^.g]-P^.l)*4; _n:=P^.n and (UInt64($F)<<_g);
    case Q^.g of
      1:begin Q^.l:=P^.l+4; Q^.e:=G[Q^.l]-2; P^.e-=1; Q^.n:=P^.n-_n+(_n<<16); if N[_n>>_g]>=(Q^.l div 4) then Q^.i+=1; end;
      2:begin Q^.l:=P^.l-4; Q^.e:=G[Q^.l]-1; P^.e-=2; Q^.n:=P^.n-_n+(_n>>16); if N[_n>>_g]<=(Q^.l div 4) then Q^.i+=1; end;
      3:begin Q^.l:=P^.l+1; Q^.e:=G[Q^.l]-8; P^.e-=4; Q^.n:=P^.n-_n+(_n<< 4); if I[_n>>_g]>=(Q^.l mod 4) then Q^.i+=1; end;
      4:begin Q^.l:=P^.l-1; Q^.e:=G[Q^.l]-4; P^.e-=8; Q^.n:=P^.n-_n+(_n>> 4); if I[_n>>_g]<=(Q^.l mod 4) then Q^.i+=1; end;
    end;
    P+=1;
  end;
end;
end.
