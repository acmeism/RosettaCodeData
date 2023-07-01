	set<double> pow5s;
	for (auto i = 1; i < MAX; i++)
	{
		pow5[i] = (double)i * i * i * i * i;
		pow5s.insert(pow5[i]);
	}
	//...
        if (pow5s.find(sum) != pow5s.end())
