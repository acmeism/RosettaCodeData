try:
    # This will cause an exception, which will then be caught.
    print(array[len(array)])
except IndexError as e:
    # Print the exception.
    print(e)
