string sNOTECARD = "Knapsack_Problem_0_1_Data.txt";
integer iMAX_WEIGHT = 400;
integer iSTRIDE = 4;
list lList = [];
default {
	integer iNotecardLine = 0;
	state_entry() {
		llOwnerSay("Reading '"+sNOTECARD+"'");
		llGetNotecardLine(sNOTECARD, iNotecardLine);
	}
	dataserver(key kRequestId, string sData) {
		if(sData==EOF) {
			//llOwnerSay("EOF");
			lList = llListSort(lList, iSTRIDE, FALSE);
			integer iTotalWeight = 0;
			integer iTotalValue = 0;
			list lKnapsack = [];
			integer x = 0;
			while(x*iSTRIDE<llGetListLength(lList)) {
				float fValueWeight = (float)llList2String(lList, x*iSTRIDE);
				string sItem = (string)llList2String(lList, x*iSTRIDE+1);
				integer iWeight = (integer)llList2String(lList, x*iSTRIDE+2);
				integer iValue = (integer)llList2String(lList, x*iSTRIDE+3);
				if(iTotalWeight+iWeight<iMAX_WEIGHT) {
					iTotalWeight += iWeight;
					iTotalValue += iValue;
					lKnapsack += [sItem, iWeight, iValue, fValueWeight];
				}
				x++;
			}
			for(x=0 ; x*iSTRIDE<llGetListLength(lKnapsack) ; x++) {
				llOwnerSay((string)x+": "+llList2String(lList, x*iSTRIDE+1)+", "+llList2String(lList, x*iSTRIDE+2)+", "+llList2String(lList, x*iSTRIDE+3));

			}
			llOwnerSay("iTotalWeight="+(string)iTotalWeight);
			llOwnerSay("iTotalValue="+(string)iTotalValue);
		} else {
			//llOwnerSay((string)iNotecardLine+": "+sData);
			if(llStringTrim(sData, STRING_TRIM)!="") {
				list lParsed = llParseString2List(sData, [","], []);
				string sItem = llStringTrim(llList2String(lParsed, 0), STRING_TRIM);
				integer iWeight = (integer)llStringTrim(llList2String(lParsed, 1), STRING_TRIM);
				integer iValue = (integer)llStringTrim(llList2String(lParsed, 2), STRING_TRIM);
				float fValueWeight = (1.0*iValue)/iWeight;
				lList += [fValueWeight, sItem, iWeight, iValue];
			}
			llGetNotecardLine(sNOTECARD, ++iNotecardLine);
		}
	}
}
