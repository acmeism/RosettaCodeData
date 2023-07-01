#!/usr/bin/env ruby

def print_verse(name)
  first_letter_and_consonants_re = /^.[^aeiyou]*/i

  full_name = name.capitalize # X
  suffixed  = case full_name[0] # Y
              when 'A','E','I','O','U'
                name.downcase
              else
                full_name.sub(first_letter_and_consonants_re, '')
              end

  b_name = "b#{suffixed}"
  f_name = "f#{suffixed}"
  m_name = "m#{suffixed}"

  case full_name[0]
  when 'B'
    b_name = suffixed
  when 'F'
    f_name = suffixed
  when 'M'
    m_name = suffixed
  end

  puts <<~END_VERSE
    #{full_name}, #{full_name}, bo-#{b_name}
    Banana-fana fo-#{f_name}
    Fee-fi-mo-#{m_name}
    #{full_name}!

  END_VERSE
end

%w[Gary Earl Billy Felix Mary Steve Chris Byron].each do |name|
    print_verse name
end
