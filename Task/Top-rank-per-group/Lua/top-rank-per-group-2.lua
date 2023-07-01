--Employee Class
local EmployeeMethods = {

}
local EmployeeMetamethods = {
    __index=EmployeeMethods,
    __tostring=function(self)
        return ("%s  %s  %s  %s"):format(self.Name,self.EmployeeId,self.Salary,self.DepartmentName)
    end,
    __metatable="Locked",
}
local EmployeeBase = {}

EmployeeBase.new = function(Name,EmployeeId,Salary,DepartmentName)
    return setmetatable({
        Name=Name,
        EmployeeId=EmployeeId,
        Salary=Salary,
        DepartmentName=DepartmentName,
    },EmployeeMetamethods)
end

--Department Class
local DepartmentMethods = {
    NewEmployee=function(self,Employee)
        table.insert(self.__Employees,Employee)
    end,
    CalculateHighestSalaries=function(self,Amount)
        local Highest = {}
        local EL = #self.__Employees
        table.sort(self.__Employees,function(a,b)
            return a.Salary > b.Salary
        end)
        for i=1,Amount do
            if i>EL then
               break
            end
            table.insert(Highest,self.__Employees[i])
        end
        return Highest
    end,
}
local DepartmentMetamethods = {
    __index=DepartmentMethods,
    __tostring=function(self)
        return ("Department %s"):format(self.Name)
    end,
    __metatable="Locked",
}
local DepartmentBase = {
    __Departments={},
}

DepartmentBase.new = function(Name)
    local Department = DepartmentBase.__Departments[Name]
    if Department then return Department end
    Department = setmetatable({
        __Employees={},
        Name=Name,
    },DepartmentMetamethods)
    DepartmentBase.__Departments[Name] = Department
    return Department
end

--Main Program

local Employees = {
    EmployeeBase.new("Tyler Bennett","E10297",32000,"D101"),
    EmployeeBase.new("John Rappl","E21437",47000,"D050"),
    EmployeeBase.new("George Woltman","E00127",53500,"D101"),
    EmployeeBase.new("Adam Smith","E63535",18000,"D202"),
    EmployeeBase.new("Claire Buckman","E39876",27800,"D202"),
    EmployeeBase.new("David McClellan","E04242",41500,"D101"),
    EmployeeBase.new("Rich Holcomb","E01234",49500,"D202"),
    EmployeeBase.new("Nathan Adams","E41298",21900,"D050"),
    EmployeeBase.new("Richard Potter","E43128",15900,"D101"),
    EmployeeBase.new("David Motsinger","E27002",19250,"D202"),
    EmployeeBase.new("Tim Sampair","E03033",27000,"D101"),
    EmployeeBase.new("Kim Arlich","E10001",57000,"D190"),
    EmployeeBase.new("Timothy Grove","E16398",29900,"D190"),
}

for _,Employee in next,Employees do
    local Department = DepartmentBase.new(Employee.DepartmentName)
    Department:NewEmployee(Employee)
end

for _,Department in next,DepartmentBase.__Departments do
    local Highest = Department:CalculateHighestSalaries(2)
    print(Department)
    for _,Employee in next,Highest do
        print("\t"..tostring(Employee))
    end
end
