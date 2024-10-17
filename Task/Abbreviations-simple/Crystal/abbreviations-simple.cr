COMMAND_TABLE =
  "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3
   compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate
   3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
   forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load
   locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2
   msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3
   refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left
   2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1"

def parse_command_table(input : String)
    cmds = {} of String => String
    table = input.strip.split

    word = table[0].upcase
    table.each do |item|
        if /[0-9]+/.match(item)
            abbreviation_length = item.to_i
            (0..word.size-abbreviation_length).each do |i|
                cmds[word[(0..abbreviation_length-1+i)]] = word
            end
        else
            word = item.upcase
            cmds[word] = word
        end
    end
    return cmds
end

def parse_user_input(input : String?, commands)
    output = ""
    unless input.nil?
        user_commands = input.strip.split
        user_commands.each do |command|
            command = command.upcase
            if commands.has_key?(command)
                output += commands[command]
            else
                output += "*error*"
            end
            output += " "
        end
    end
    return output
end

cmds = parse_command_table(COMMAND_TABLE)
puts "Input:"
user_input = gets
puts "Output:"
puts parse_user_input(user_input, cmds)
