// still inside struct Accumulator_
	// various operator() implementations provide a de facto multimethod
	Accumulator_& operator()(int more)
	{
		if (auto i = CoerceInt(*val_))
			Set(+i + more);
		else if (auto d = CoerceDouble(*val_))
			Set(+d + more);
		else
			THROW("Accumulate(int) failed");
		return *this;
	}
	Accumulator_& operator()(double more)
	{
		if (auto d = CoerceDouble(*val_))
			Set(+d + more);
		else
			THROW("Accumulate(double) failed");
		return *this;
	}
	Accumulator_& operator()(const String_& more)
	{
		if (auto s = CoerceString(*val_))
			Set(+s + more);
		else
			THROW("Accumulate(string) failed");
		return *this;
	}
};
