import std.range;

struct PowerSet(R)
	if (isRandomAccessRange!R)
{
	R r;
	size_t position;

	struct PowerSetItem
	{
		R r;
		size_t position;

		private void advance()
		{
			while (!(position & 1))
			{
				r.popFront();
				position >>= 1;
			}
		}

		@property bool empty() { return position == 0; }
		@property auto front()
		{
			advance();
			return r.front;
		}
		void popFront()
		{
			advance();
			r.popFront();
			position >>= 1;
		}
	}

	@property bool empty() { return position == (1 << r.length); }
	@property PowerSetItem front() { return PowerSetItem(r.save, position); }
	void popFront() { position++; }
}

auto powerSet(R)(R r) { return PowerSet!R(r); }
