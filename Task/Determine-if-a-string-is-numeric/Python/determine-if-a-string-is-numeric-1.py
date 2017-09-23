def is_numeric(s):
    try:
        float(s)
        return True
    except (ValueError, TypeError):
        return False

is_numeric('123.0')
