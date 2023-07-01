program rs232(input, output, stdErr);
type
	{$packEnum 2}{$scopedEnums off}
	pin = (carrierDetect, receivedData, transmittedData, dataTerminalReady,
		signalGround, dataSetReady, requestToSend, clearToSend, ringIndicator);
	{$packSet 2}
	pins = set of pin;
var
	signal: pins;
	// for demonstration purposes, in order to reveal the memory layout
	signalMemoryStructure: word absolute signal;
	{$if sizeOf(signal) <> sizeOf(word)} // just as safe-guard
		{$fatal signal size}
	{$endIf}
begin
	signal := [];
	include(signal, signalGround); // equivalent to signal := signal + [signalGround];
	// for demonstration purposes: obviously we know this is always `true`
	if signalGround in signal then
	begin
		writeLn(binStr(signalMemoryStructure, bitSizeOf(signal)));
	end;
end.
