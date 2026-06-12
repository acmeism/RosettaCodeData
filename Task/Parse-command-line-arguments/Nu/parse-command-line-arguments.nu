def main [
	input: string     # File to operate on
	output?: string  # File to write to
	--verbose (-v):   # Be verbose
] {
	{
		Input: $input
		Output: $output
		Verbose: $verbose
	}
}
