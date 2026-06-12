type
	someOrdinalType = boolean;
	sumDataType = record
			case tag: someOrdinalType of
				false: (
					number: integer;
				);
				true: (
					character: char;
				);
		end;
