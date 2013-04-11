declare
  class Printer
     attr ink:5

     feat id backup

     meth init(id:ID backup:Backup<=unit)
        self.id = ID
        self.backup = Backup
     end

     meth print(Line)=Msg
        if @ink == 0 then
           if self.backup == unit then
              raise outOfInk end
           else
              {self.backup Msg}
           end
        else
           {System.printInfo self.id#": "}
           for C in Line do
              {System.printInfo [C]}
           end
           {System.printInfo "\n"}
           ink := @ink - 1
        end
     end
  end
