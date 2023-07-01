def is_numeric(literal):
    """Return whether a literal can be parsed as a numeric value"""
    castings = [int, float, complex,
        lambda s: int(s,2),  #binary
        lambda s: int(s,8),  #octal
        lambda s: int(s,16)] #hex
    for cast in castings:
        try:
            cast(literal)
            return True
        except ValueError:
            pass
    return False
