Shoes.app do
  string = ask('Enter a string:')
  begin
    number = ask('Enter the number 75000:')
  end while number.to_i != 75000
  para %Q{you entered the string "#{string}" and the number #{number}}
end
