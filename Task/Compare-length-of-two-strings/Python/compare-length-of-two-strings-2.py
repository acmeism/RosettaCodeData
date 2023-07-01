"""
An example code for the task "Compare length of two strings" (Rosseta Code).

This example code can handle not only strings, but any objects.
"""


def _(message):
    """Translate: an placeholder for i18n and l10n gettext or similar."""
    return message


def compare_and_report_length(*objects, sorted_=True, reverse=True):
    """
    For objects given as parameters it prints which of them are the longest.

    So if the parameters are strings, then the strings are printed, their
    lengths and classification as the longest, shortest or average length.

    Note that for N > 0 such objects (e.g., strings, bytes, lists) it is
    possible that exactly M > 0 of them will be of the maximum length, K > 0 of
    them will be of the minimum length. In particular, it is possible that all
    objects will be exactly the same length. So we assume that if an object has
    both the maximum and minimum length, it is referred to as a string with the
    maximum length.

    Args:
        *objects (object): Any objects with defined length.
        sorted_ (bool, optional): If sorted_ is False then objects are not
                sorted. Defaults to True.
        reverse (bool, optional): If reverse is True and sorted_ is True
                objects are sorted in the descending order. If reverse is False
                and sorted_ is True objects are sorted in the ascending order.
                Defaults to True.

    Returns:
        None.
    """
    lengths = list(map(len, objects))
    max_length = max(lengths)
    min_length = min(lengths)
    lengths_and_objects = zip(lengths, objects)

    # Longer phrases make translations into other natural languages easier.
    #
    has_length = _('has length')
    if all(isinstance(obj, str) for obj in objects):
        predicate_max = _('and is the longest string')
        predicate_min = _('and is the shortest string')
        predicate_ave = _('and is neither the longest nor the shortest string')
    else:
        predicate_max = _('and is the longest object')
        predicate_min = _('and is the shortest object')
        predicate_ave = _('and is neither the longest nor the shortest object')

    if sorted_:
        lengths_and_objects = sorted(lengths_and_objects, reverse=reverse)

    for length, obj in lengths_and_objects:
        if length == max_length:
            predicate = predicate_max
        elif length == min_length:
            predicate = predicate_min
        else:
            predicate = predicate_ave
        print(obj, has_length, length, predicate)


A = 'I am string'
B = 'I am string too'
LIST = ["abcd", "123456789", "abcdef", "1234567"]


print('Two strings')
print()
compare_and_report_length(A, B)
print()

print('A list of strings')
print()
compare_and_report_length(*LIST)
print()
