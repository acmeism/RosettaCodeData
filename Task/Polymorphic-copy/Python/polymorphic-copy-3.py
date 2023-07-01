target = source.__class__()  # Create an object of the same type
if hasattr(source, 'items') and callable(source.items):
    for key,value in source.items:
        target[key] = value
elif hasattr(source, '__len__'):
    target = source[:]
else:  # Following is not recommended. (see below).
    target = source
