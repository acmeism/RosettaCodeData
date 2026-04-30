-- Seed the random number generator with the current system time
math.randomseed(os.time())

-- Define a `Helper` table to store utility functions
local Helper = {}

-- Create a 1D table (array) filled with the same value
--- @param len number number of elements
--- @param val any value to fill each element with
function Helper.newFilledTable(len, val)
    local t = {}

    for i = 1, len do
        t[i] = val
    end

    return t
end

-- Create a 2D table (rows x cols) initialized with a given value
---@param rows number number of rows
---@param cols number number of columns
---@param init any initial value for each cell
function Helper.new2D(rows, cols, init)
    local b = {}

    for r = 1, rows do
        b[r] = {}
        for c = 1, cols do
            b[r][c] = init
        end
    end

    return b
end

-- Compare two tables element by element for equality
-- Works only for flat 1D arrays
function Helper.tablesEqual(tbl1, tbl2)
    if #tbl1 ~= #tbl2 then
        error("Tables must have equal length")
    end
    if #tbl1 == 0 and #tbl2 == 0 then
        return true
    end

    for i = 1, #tbl1 do
        if tbl1[i] ~= tbl2[i] then
            return false
        end
    end
    return true
end

-- Initialise an 8x8 chess board (empty, filled with nils)
local board = Helper.new2D(8, 8, nil)

-- Place white and black kings randomly on the board
-- Ensures:
--   1. They are not on the same square
--   2. They are not adjacent (Chebyshev distance > 1)
local function placeKings(board)
    local attempts = 0

    while true do
        attempts = attempts + 1
        if attempts > 10000 then
            error("Failed to place kings after many attempts")
        end

        -- Random row and column for each king
        local wr = math.random(1, 8)
        local wc = math.random(1, 8)
        local br = math.random(1, 8)
        local bc = math.random(1, 8)
        local skip1 = false
        local skip2 = false

        -- Ensure kings are not on the same square
        if wr == br and wc == bc then
            skip1 = true
        end

        if not skip1 then
            -- Check Chebyshev distance (max of row/col difference)
            local dr = math.abs(wr-br)
            local dc = math.abs(wc-bc)
            local chebyshev = (dr > dc) and dr or dc

            -- Skip if kings are adjacent
            if chebyshev <= 1 then
                skip2 = true
            end

            -- Place kings if squares are empty and valid
            if not skip2 then
                if not board[wr][wc] and not board[br][bc] then
                    board[wr][wc] = "K"  -- White king
                    board[br][bc] = "k"  -- Black king
                    return
                end
            end
        end
    end
end

-- Populate the board with a given set of pieces
---@param board table board
---@param pieces string string of piece characters (e.g. "PPPPPPPP")
---@param isPawn boolean boolean, true if placing pawns (to avoid ranks 1 and 8)
local function populate(board, pieces, isPawn)
    local piecesAmount = #pieces

    for i = 1, piecesAmount do
        local pieceChar = pieces:sub(i, i)
        local attempts = 0

        while true do
            attempts = attempts + 1
            if attempts > 5000 then
                error("Failed to place piece "..pieceChar)
            end

            -- Choose a random square
            local r = math.random(1, 8)
            local c = math.random(1, 8)

            if board[r][c] then
                -- Skip if already occupied
            else
                -- Prevent pawns on promotion ranks (1 or 8)
                if isPawn and (r == 1 or r == 8) then
                else
                    board[r][c] = pieceChar
                    break
                end
            end
        end
    end
end

-- Convert the board into Forsyth-Edwards Notation (FEN)
-- Only encodes piece placement and default values for side-to-move, castling, etc.
local function toFENFormat(board)
    local result = ""

    -- Loop through ranks 8 to 1 (FEN goes top-down)
    for r = 8, 1, -1 do
        local emptyCount = 0

        for c = 1, 8 do
            local row = board[r]
            local ch = row and row[c]

            if not ch then
                -- Count consecutive empty squares
                emptyCount = emptyCount + 1
            else
                -- Insert number for empty squares, then piece
                if emptyCount > 0 then
                    result = result .. tostring(emptyCount)
                    emptyCount = 0
                end
                result = result .. tostring(ch)
            end
        end

        -- Handle trailing empty squares in row
        if emptyCount > 0 then
            result = result .. tostring(emptyCount)
        end

        -- Add rank separator except for last row
        if r > 1 then
            result = result .. "/"
        end
    end

    -- Append default FEN suffix ("w - - 0 1")
    return result .. " w - - 0 1"
end

-- Main function --

placeKings(board)
populate(board, "PPPPPPPP", true)
populate(board, "pppppppp", true)
populate(board, "RNBQBNR", false)
populate(board, "rnbqbnr", false)

print(toFENFormat(board))
