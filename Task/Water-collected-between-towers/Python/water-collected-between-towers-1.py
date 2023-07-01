def water_collected(tower):
    N = len(tower)
    highest_left = [0] + [max(tower[:n]) for n in range(1,N)]
    highest_right = [max(tower[n:N]) for n in range(1,N)] + [0]
    water_level = [max(min(highest_left[n], highest_right[n]) - tower[n], 0)
        for n in range(N)]
    print("highest_left:  ", highest_left)
    print("highest_right: ", highest_right)
    print("water_level:   ", water_level)
    print("tower_level:   ", tower)
    print("total_water:   ", sum(water_level))
    print("")
    return sum(water_level)

towers = [[1, 5, 3, 7, 2],
    [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
    [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
    [5, 5, 5, 5],
    [5, 6, 7, 8],
    [8, 7, 7, 6],
    [6, 7, 10, 7, 6]]

[water_collected(tower) for tower in towers]
