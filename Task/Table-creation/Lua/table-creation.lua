Columns = {};
Columns.ID = {};
Columns.FName = {};
Columns.LName = {};
Columns.Email = {};
Columns.Names = {"ID","FName","LName","Email"};

function Insert(id,fname,lname,email)
	table.insert(Columns.ID, id);
	table.insert(Columns.FName, fname);
	table.insert(Columns.LName, lname);
	table.insert(Columns.Email, email);
end

for i,v in pairs(Columns.ID) do
	print(v,Columns.FName[i],Columns.LName[i]);
end

function getMax(Table)
	local cmax = #Table
	for i,v in pairs(Columns[Table]) do
		if #tostring(v) > cmax then
			cmax = #tostring(v)
		end
	end
	return cmax;
end

function listTables()
	local Total = (#Columns.Names*2)+1;
	for i,v in pairs(Columns.Names) do
		Total = Total + getMax(v);
	end
	print()
	local CS = "|";
	for i,v in pairs(Columns.Names) do
		CS = CS.." "..v..string.rep(" ",(getMax(v)-#v)).."|";
	end
	print(string.rep("-",Total).."\n"..CS.."\n"..string.rep("-",Total))
	for it = 1,#Columns.ID do
		CS = "|";
		for i,v in pairs(Columns.Names) do
			CS = CS.." "..Columns[v][it]..string.rep(" ",(getMax(v)-(#tostring((Columns[v][it]))))).."|";
		end
		print(CS);
	end
	print(string.rep("-",Total));
end

--[[Inserting items]]--
Insert(#Columns.ID,"John","Doel","John.Doe000@ExampleEmail.com");
Insert(#Columns.ID,"Jane","Miller","Jane.Miller000@ExampleEmail.com");
Insert(#Columns.ID,"Eerie","Crate","Eeriecrate@ExampleEmail.com");
--[[               ]]--

listTables();
