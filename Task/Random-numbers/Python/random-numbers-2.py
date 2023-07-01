>>> def quick_check(numbers):
    count = len(numbers)
    mean = sum(numbers) / count
    sdeviation = (sum((i - mean)**2 for i in numbers) / count)**0.5
    return mean, sdeviation

>>> quick_check(values)
(1.0140373306786599, 0.49943411329234066)
>>>
