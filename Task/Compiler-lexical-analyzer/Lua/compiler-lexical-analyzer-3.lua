-- module lexer
local M = {} -- only items added to M will publicly available (via 'return M' at end)
local string, io, coroutine, yield = string, io, coroutine, coroutine.yield
local error, pcall, type = error, pcall, type

local finder = require 'lpeg_token_finder'
_ENV = {}

-- produces a token iterator given a source line iterator
function M.tokenize_lineiter(lineiter)
    local function fatal(err)
        local msgtext = {
            unfinished_comment = "EOF inside comment started",
            invalid_token = "Invalid token",
            bad_escseq = "Invalid escape sequence",
        }
        local fmt = "LEX ERROR: %s at line %d, column %d"
        error(string.format(fmt, msgtext[err.err], err.line, err.column))
    end

    return coroutine.wrap(function()
        local line_number = 0
        local line_pos
        local in_comment -- where unfinished comment started

        for line in lineiter do
            line_number = line_number + 1
            line_pos = 1

            local function scanline() -- yield current line's tokens
                repeat
                    local token, pos =
                        finder.find_token(line, line_pos, line_number, in_comment)
                    if token then
                        line_pos = pos
                        in_comment = nil
                        yield(token)
                    end
                until token == nil
            end

            if line then
                local ok, err = pcall(scanline)
                if ok then
                    in_comment = nil
                elseif type(err) == 'table' and err.err=='unfinished_comment' then
                    if not(in_comment and err.column==1) then
                        in_comment = err
                    end
                elseif type(err) == 'table' then
                    fatal(err)
                else
                    error(err) -- some internal error
                end
            end
        end
        if in_comment then
            fatal(in_comment)
        else
            yield{name='End_of_input', line=line_number+1, column=1}
        end
        return nil
    end)
end

------------------- exports -----------------------------

lexer = M.tokenize_lineiter

function M.tokenize_file(filename)
    return lexer(io.lines(filename))
end

function M.tokenize_text(text)
    return lexer(text:gmatch('[^\n]+'))
end

-- M._INTERNALS = _ENV
return M
