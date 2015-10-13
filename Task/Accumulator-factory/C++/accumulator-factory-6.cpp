std::ostream& operator<<(std::ostream& dst, const Accumulator_& acc)
{
	return acc.val_->Write(dst);
}
