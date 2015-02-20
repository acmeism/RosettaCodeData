class RosettaDemo
{
	static var setA = ['the', 'that', 'a'];
	static var setB = ['frog', 'elephant', 'thing'];
	static var setC = ['walked', 'treaded', 'grows'];
	static var setD = ['slowly', 'quickly'];

	static public function main()
	{
		Sys.print(ambParse([ setA, setB, setC, setD ]).toString());
	}

	static function ambParse(sets : Array<Array<String>>)
	{
		var ambData : Dynamic = amb(sets);

		for (data in 0...ambData.length)
		{
			var tmpData = parseIt(ambData[data]);
			var tmpArray = tmpData.split(' ');
			tmpArray.pop();
			if (tmpArray.length == sets.length)
			{
				return tmpData;
			}
		}

		return '';
	}

	static function amb(startingWith : String = '', sets : Array<Array<String>>) : Dynamic
	{
		if (sets.length == 0 || sets[0].length == 0) return;

		var match : Dynamic = [];
		for (reference in sets[0])
		{
			if (startingWith == '' || startingWith == reference.charAt(0))
			{
				var lastChar = reference.charAt(reference.length-1);
				if (Std.is(amb(lastChar, sets.slice(1)), Array))
				{
					match.push([ reference, amb(lastChar, sets.slice(1))]);
				}
				else
				{
					match.push([ reference ]);
				}
			}
		}
		return match;
	}

	static function parseIt(data : Dynamic)
	{
		var retData = '';
		if (Std.is(data, Array))
		{
			for (elements in 0...data.length)
			{
				if (Std.is(data[elements], Array))
				{
					retData = retData + parseIt(data[elements]);
				}
				else
				{
					retData = retData + data[elements] + ' ';
				}
			}
		}
		return retData;
	}
}
