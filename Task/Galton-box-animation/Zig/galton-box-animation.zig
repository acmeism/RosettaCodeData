const std = @import("std");
const rand = std.rand;
const time = std.time;

const PEG_LINES = 20;
const BALLS = 10;

fn boardSize(comptime peg_lines: u16) u16 {
    var i: u16 = 0;
    var size: u16 = 0;
    inline while (i <= peg_lines) : (i += 1) {
        size += i + 1;
    }
    return size;
}

const BOARD_SIZE = boardSize(PEG_LINES);

fn stepBoard(board: *[BOARD_SIZE]u1, count: *[PEG_LINES + 1]u8) void {
    var prng = rand.DefaultPrng.init(@bitCast(time.timestamp()));

    var p: u8 = 0;
    var sum: u16 = 0;
    while (p <= PEG_LINES) : (p += 1) {
        const pegs = PEG_LINES - p;
        var i: u16 = 0;
        while (i < pegs + 1) : (i += 1) {
            if (pegs != PEG_LINES and board[BOARD_SIZE - 1 - sum - i] == 1) {
                if (prng.random().boolean()) {
                    board.*[BOARD_SIZE - 1 - sum - i + pegs + 1] = 1;
                } else {
                    board.*[BOARD_SIZE - 1 - sum - i + pegs + 2] = 1;
                }
            } else if (pegs == PEG_LINES and board[BOARD_SIZE - 1 - sum - i] == 1) {
                count.*[pegs - i] += 1;
            }
            board.*[BOARD_SIZE - 1 - sum - i] = 0;
        }
        sum += pegs + 1;
    }
}

fn printBoard(board: *[BOARD_SIZE]u1, count: *[PEG_LINES + 1]u8) !void {
    const stdout = std.io.getStdOut();
    _ = try stdout.write("\x1B[2J\x1B[1;1H");
    var pegs: u16 = 0;
    var sum: u16 = 0;
    while (pegs <= PEG_LINES) : (pegs += 1) {
        var i: u16 = 0;
        while (i < (PEG_LINES - pegs)) : (i += 1) _ = try stdout.write(" ");
        i = 0;
        while (i < pegs + 1) : (i += 1) {
            const spot = if (board[i + sum] == 1) "o" else " ";
            _ = try stdout.write(spot);
            if (i != pegs) _ = try stdout.write("*");
        }
        sum += pegs + 1;
        _ = try stdout.write("\n");
    }
    for (count) |n| {
        const num_char = [2]u8{'0' + n, ' '};
        _ = try stdout.write(&num_char);
    }
    _ = try stdout.write("\n");
}

pub fn main() !void {
    var board: [BOARD_SIZE]u1 = [_]u1{0} ** BOARD_SIZE;
    var bottom_count: [PEG_LINES+1]u8 = [_]u8{0} ** (PEG_LINES + 1);

    var i: u16 = 0;
    while (i < PEG_LINES + BALLS + 1) : (i += 1) {
        if (i < BALLS) board[0] = 1;

        try printBoard(&board, &bottom_count);
        stepBoard(&board, &bottom_count);
        time.sleep(150000000);
    }
}
