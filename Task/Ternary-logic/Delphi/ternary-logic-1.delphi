unit TrinaryLogic;

interface

//Define our own type for ternary logic.
//This is actually still a Boolean, but the compiler will use distinct RTTI information.
type
    TriBool = type Boolean;

const
    TTrue:TriBool = True;
    TFalse:TriBool = False;
    TMaybe:TriBool = TriBool(2);

function TVL_not(Value: TriBool): TriBool;
function TVL_and(A, B: TriBool): TriBool;
function TVL_or(A, B: TriBool): TriBool;
function TVL_xor(A, B: TriBool): TriBool;
function TVL_eq(A, B: TriBool): TriBool;

implementation

Uses
    SysUtils;

function TVL_not(Value: TriBool): TriBool;
begin
    if Value = True Then
        Result := TFalse
    else If Value = False Then
        Result := TTrue
    else
        Result := Value;
end;

function TVL_and(A, B: TriBool): TriBool;
begin
    Result := TriBool(Iff(Integer(A * B) > 1, Integer(TMaybe), A * B));
end;

function TVL_or(A, B: TriBool): TriBool;
begin
    Result := TVL_not(TVL_and(TVL_not(A), TVL_not(B)));
end;

function TVL_xor(A, B: TriBool): TriBool;
begin
    Result := TVL_and(TVL_or(A, B), TVL_not(TVL_or(A, B)));
end;

function TVL_eq(A, B: TriBool): TriBool;
begin
    Result := TVL_not(TVL_xor(A, B));
end;

end.
