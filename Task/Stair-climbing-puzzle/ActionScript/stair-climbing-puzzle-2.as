function stepUp()
{
	if(!step())
	{
		stepUp();
		stepUp();
	}
}
