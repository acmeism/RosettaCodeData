{Enumerate pin assignments}

type TRS232Pins = (rpCarrierDetect, rpReceivedData, rpTransmittedData,
		   rpDataTerminalReady, rpSignalGround, rpDataSetReady,
		   rpRequestToSend, rpClearToSend, rpRingIndicator);
{Make into a set}
type TPinSet = set of TRS232Pins;

var Pins: TPinSet;	{Global variable holding a set of pins}

procedure ShowMemory(Memo: TMemo; Name: string; SetPins: TPinSet);
{Extract the set data from memory and display it}
var S: string;
var P: PWord;
begin
P:=@Pins;
Pins:=SetPins;
S:=Name;
S:=S+IntToBin(P^, 16, True);
Memo.Lines.Add(S);
end;



procedure ShowPinsMemory(Memo: TMemo);
begin
ShowMemory(Memo,'Empty:              ',[]);
ShowMemory(Memo,'Carrier Detect:     ',[rpCarrierDetect]);
ShowMemory(Memo,'Received Data:      ',[rpReceivedData]);
ShowMemory(Memo,'Transmitted Data:   ',[rpTransmittedData]);
ShowMemory(Memo,'Data Terminal Ready:',[rpDataTerminalReady]);
ShowMemory(Memo,'Signal Ground:      ',[rpSignalGround]);
ShowMemory(Memo,'Data Set Ready:     ',[rpDataSetReady]);
ShowMemory(Memo,'Request To Send:    ',[rpRequestToSend]);
ShowMemory(Memo,'Clear To Send:      ',[rpClearToSend]);
ShowMemory(Memo,'Ring Indicator:     ',[rpRingIndicator]);
end;
