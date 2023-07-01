local function utf8Length(str)
	local len = 0
	for char in str:gmatch"[\1-\127\194-\244][\128-\191]*" do
		len = len + 1
	end
	return len
end

local tests = {
	"snakeCase", "snake_case",
	"variable_10_case", "variable10Case",
	"ɛrgo rE tHis",
	"hurry-up-joe!",
	"c://my-docs/happy_Flag-Day/12.doc",
	"  spaces  ",
	"  internal space  ",
}

local function convert(label, converter)
	print(label..":")
	for _, str in ipairs(tests) do
		print((" "):rep(35-utf8Length(str)) .. str .. "  =>  " .. converter(str))
	end
	print()
end

convert("snake_case to camelCase", function(str)  return toCamelCase  (str, "_")  end)
convert("space case to camelCase", function(str)  return toCamelCase  (str, " ")  end)
convert("kebab-case to camelCase", function(str)  return toCamelCase  (str, "-")  end)
convert("camelCase to snake_case", function(str)  return fromCamelCase(str, "_")  end)
