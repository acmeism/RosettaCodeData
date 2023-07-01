# optional, but task function depends on it as written
def validate_position(candidate: str):
    assert (
        len(candidate) == 8
    ), f"candidate position has invalide len = {len(candidate)}"

    valid_pieces = {"R": 2, "N": 2, "B": 2, "Q": 1, "K": 1}
    assert {
        piece for piece in candidate
    } == valid_pieces.keys(), f"candidate position contains invalid pieces"
    for piece_type in valid_pieces.keys():
        assert (
            candidate.count(piece_type) == valid_pieces[piece_type]
        ), f"piece type '{piece_type}' has invalid count"

    bishops_pos = [index for index,
                   value in enumerate(candidate) if value == "B"]
    assert (
        bishops_pos[0] % 2 != bishops_pos[1] % 2
    ), f"candidate position has both bishops in the same color"

    assert [piece for piece in candidate if piece in "RK"] == [
        "R",
        "K",
        "R",
    ], "candidate position has K outside of RR"


def calc_position(start_pos: str):
    try:
        validate_position(start_pos)
    except AssertionError:
        raise AssertionError
    # step 1
    subset_step1 = [piece for piece in start_pos if piece not in "QB"]
    nights_positions = [
        index for index, value in enumerate(subset_step1) if value == "N"
    ]
    nights_table = {
        (0, 1): 0,
        (0, 2): 1,
        (0, 3): 2,
        (0, 4): 3,
        (1, 2): 4,
        (1, 3): 5,
        (1, 4): 6,
        (2, 3): 7,
        (2, 4): 8,
        (3, 4): 9,
    }
    N = nights_table.get(tuple(nights_positions))

    # step 2
    subset_step2 = [piece for piece in start_pos if piece != "B"]
    Q = subset_step2.index("Q")

    # step 3
    dark_squares = [
        piece for index, piece in enumerate(start_pos) if index in range(0, 9, 2)
    ]
    light_squares = [
        piece for index, piece in enumerate(start_pos) if index in range(1, 9, 2)
    ]
    D = dark_squares.index("B")
    L = light_squares.index("B")

    return 4 * (4 * (6*N + Q) + D) + L

if __name__ == '__main__':
    for example in ["QNRBBNKR", "RNBQKBNR", "RQNBBKRN", "RNQBBKRN"]:
        print(f'Position: {example}; Chess960 PID= {calc_position(example)}')
