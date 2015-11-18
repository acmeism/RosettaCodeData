// recognize cumulants by type
boost::optional<int> CoerceInt(const CumulantBase_& c)
{
	if (auto p = dynamic_cast<const Cumulant_<int>*>(&c))
		return p->val_;
	return boost::optional<int>();
}
boost::optional<double> CoerceDouble(const CumulantBase_& c)
{
	if (auto p = dynamic_cast<const Cumulant_<double>*>(&c))
		return p->val_;
	if (auto i = CoerceInt(c))
		return boost::optional<double>(i);
	return boost::optional<double>();
}
boost::optional<String_> CoerceString(const CumulantBase_& c)
{
	if (auto p = dynamic_cast<const Cumulant_<String_>*>(&c))
		return p->val_;
	return boost::optional<String_>();
}
