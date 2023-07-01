MODULE RosettaGreys;
IMPORT Views, Ports, Properties, Controllers, StdLog;

CONST
	(* orient values *)
	left = 1;
	right = 0;
	
TYPE
	View = POINTER TO RECORD
		(Views.View)
	END;
	
	PROCEDURE LoadGreyPalette(VAR colors: ARRAY OF Ports.Color);
	VAR
		i, step, hue: INTEGER;
	BEGIN
		step := 255 DIV LEN(colors);
		FOR i := 1 TO LEN(colors) DO
			hue := i * step;
			colors[i - 1] := Ports.RGBColor(hue,hue,hue)
		END
	END LoadGreyPalette;
	
	PROCEDURE (v: View) Restore(f: Views.Frame; l, t, r, b: INTEGER);
	VAR
		i, w, h: INTEGER;
		colors: POINTER TO ARRAY OF Ports.Color;
		
		PROCEDURE Draw(row, cols: INTEGER; orient: INTEGER);
		VAR
			w: INTEGER;
			c: Ports.Color;
		BEGIN
			NEW(colors,cols);LoadGreyPalette(colors^);
			w := (r - l) DIV cols;
			FOR i := 1 TO cols DO
				IF orient = left THEN c := colors[cols - i] ELSE c := colors[i - 1] END;
				f.DrawRect((l + w) * (i - 1), t + (row - 1) * h, (l + w) * i, t + row * h,Ports.fill,c);
			END
		END Draw;
	BEGIN
		h := (b - t) DIV 4;
		Draw(1,8,right);
		Draw(2,16,left);
		Draw(3,32,right);
		Draw(4,64,left);
	END Restore;
	
	PROCEDURE (v: View) HandlePropMsg(VAR msg: Properties.Message);
	CONST
		min = 5 * Ports.mm;
		max = 50 * Ports.mm;
	VAR
		stdProp: Properties.StdProp;
		prop: Properties.Property;
	BEGIN
		WITH msg: Properties.SizePref DO
			IF (msg.w = Views.undefined) OR (msg.h = Views.undefined) THEN
				msg.w := 100 * Ports.mm;
				msg.h := 35 * Ports.mm
			END
		ELSE (* ignore other messages *)
		END
	END HandlePropMsg;
	
	PROCEDURE Deposit*;
	VAR
		v: View;
	BEGIN
		NEW(v);
		Views.Deposit(v)
	END Deposit;
END RosettaGreys.

 "RosettaGreys.Deposit; StdCmds.Open"
