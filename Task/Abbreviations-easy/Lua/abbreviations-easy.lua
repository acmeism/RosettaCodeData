#!/usr/bin/lua

local list1 = [[
   Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst
 COMPress COpy COUnt COVerlay CURsor DELete CDelete Down DUPlicate
 Xedit EXPand EXTract Find NFind NFINDUp NFUp CFind FINdup FUp
 FOrward GET Help HEXType Input POWerinput Join SPlit SPLTJOIN
 LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO MErge
 MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query
  QUIT READ  RECover REFRESH RENum REPeat  Replace CReplace
  RESet  RESTore  RGTLEFT RIght LEft  SAVE  SET SHift SI  SORT
  SOS  STAck STATus  TOP TRAnsfer Type Up ]]


local indata1 = [[riG  rePEAT copies  put mo   rest    types
   fup.    6       poweRin]]

local indata2 = [[ALT  aLt  ALTE  ALTER  AL  ALF ALTERS TER A]]
local indata3 = [[o  ov  oVe  over  overL  overla]]

local function split(text)
   local result = {}
   for w in string.gmatch(text, "%g+") do
      result[#result+1]=w
      -- print(#result,w,#w)
   end
   return result
end


local function print_line( t )
   for i = 1,#t do
      io.write( string.format("%s ", t[i] ) )
   end
   print()
end


local function is_valid(cmd,abbrev)
   --print(abbrev,cmd,"##")

   local sm = string.match( cmd:lower(), abbrev:lower() )
   if sm == nil then return -1 end

   -- test if any lowercase in "cmd"
   if false then do -- NOTE!: requirement spec error .. put not equal PUT
	 local lowcase = string.match(cmd,"%l+")
	 if lowcase == nil then return -2 end
	 if #lowcase < 1 then return -3 end
		 end
   end

   -- test if abbrev is too long
   if #abbrev > #cmd then return -4 end

   --- num caps in "cmd" is minimum length of abbrev
   local caps = string.match(cmd,"%u+")
   if #abbrev < #caps then return -5 end

   local s1 = abbrev:sub(1,#caps)
   local s2 = cmd:sub(1,#caps)
   if s1:lower() ~= s2:lower() then return -6 end

   return 1
end

local function start()
   local t1 = {}
   local t2 = {}
   local result = {}
   t1 = split(list1)
   t2 = split(indata1)
   print_line(t2);

   for i = 1,#t2 do
      good = 0
      for j = 1,#t1 do
	 local abbrev = t2[i]
	 local cmd = t1[j]
	 good = is_valid(cmd,abbrev)
	 if good==1 then do
	       result[#result+1] = t1[j]:upper()
	       break end
	 end  --if
      end --for j
      if good < 1 then result[#result+1] = "*error*" end
   end --for i
   print_line(result)
end

start() -- run the program
