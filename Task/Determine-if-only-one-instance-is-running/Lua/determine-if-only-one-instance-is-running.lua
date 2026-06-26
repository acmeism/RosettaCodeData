local dsep = package.config:sub(1,1)

local Exists = function (path) return os.rename(path, path) end
local Dirname do
	local dirnamepatt = '^.*' .. dsep
	Dirname = function (path) return (path or ''):match(dirnamepatt) end
end

local uuid = 'LuaOneInstanceExample'
local tmpdir = (Dirname(os.tmpname()) or os.getenv"HOME") .. dsep
local lockname = tmpdir .. uuid

if Exists(lockname) then
	print"Another instance already running, exiting"
	os.exit(11)
end

local H = io.open(lockname,"w") or error('Cannot create/write temporary file')
H:close()

local function doeverything()
	-- Everything goes inside this function
	-- If an error happens, pcall will catch it and os.delete() will release the lock
end

pcall(doeverything)

-- Release the lock
os.remove(lockname)

