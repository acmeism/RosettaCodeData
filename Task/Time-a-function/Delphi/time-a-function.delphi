type TResolution=(rsSeconds,rsMiliSeconds);

type TCodeTimer=class(TPanel)
 private
  FResolution: TResolution;
 public
  WrkCount,TotCount: longint;
  constructor Create(AOwner: TComponent); override;
  procedure Reset;
  procedure Start;
  procedure Stop;
  procedure Display;
 published
  property Resolution: TResolution read FResolution write FResolution default rsMiliSeconds;
 end;


function GetHiResTick: integer;
var C: TLargeInteger;
begin
QueryPerformanceCounter(C);
Result:=C;
end;




constructor TCodeTimer.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
FResolution:=rsMiliSeconds;
end;



procedure TCodeTimer.Reset;
begin
WrkCount:=0;
TotCount:=0;
end;


procedure TCodeTimer.Start;
begin
WrkCount:=GetHiResTick;
end;


procedure TCodeTimer.Stop;
begin
TotCount:=TotCount+(GetHiResTick-WrkCount);
end;

procedure TCodeTimer.Display;
begin
if FResolution=rsSeconds then Caption:=FloatToStrF(TotCount/1000000,ffFixed,18,3)+' Sec.'
else Caption:=FloatToStrF(TotCount/1000,ffFixed,18,3)+' ms.'
end;
