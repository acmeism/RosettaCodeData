require("lfs")

function mkdir (path)
  local sep, pStr = package.config:sub(1, 1), ""
  for dir in path:gmatch("[^" .. sep .. "]+") do
    pStr = pStr .. dir .. sep
    lfs.mkdir(pStr)
  end
end

mkdir("C:\\path\\to\\dir") -- Quoting backslashes requires escape sequence
