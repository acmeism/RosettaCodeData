lexer = require 'lexer'
format, gsub = string.format, string.gsub

function printf(fmt, ...) print(format(fmt, ...)) end

function stringrep(str)
    local subst = {['\n'] = "\\n", ['\\'] = '\\\\'}
    return format('"%s"', gsub(str, '[\n\\]', subst))
end

function display(text)
    for t in lexer.tokenize_text(text) do
        local value = (t.name=='String') and stringrep(t.value) or t.value or ''
        printf("%4d %3d %-15s %s", t.line, t.column, t.name, value)
    end
end

----------------------- test cases from Rosetta spec ------------------------
testing = true
if testing then
-- test case 1
display[[
/*
  Hello world
 */
print("Hello, World!\n");]]
print()

-- test ercase 2
display[[
/*
  Show Ident and Integers
 */
phoenix_number = 142857;
print(phoenix_number, "\n");]]
print()
-- etc.
end
