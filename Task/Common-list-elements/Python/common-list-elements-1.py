"""Find distinct common list elements using set.intersection."""

def common_list_elements(*lists):
    return list(set.intersection(*(set(list_) for list_ in lists)))


if __name__ == "__main__":
    test_cases = [
        ([2, 5, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 9, 8, 4], [1, 3, 7, 6, 9]),
        ([2, 2, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 2, 2, 4], [2, 3, 7, 6, 2]),
    ]

    for case in test_cases:
        result = common_list_elements(*case)
        print(f"Intersection of {case} is {result}")
