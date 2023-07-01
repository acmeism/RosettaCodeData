def common_directory_path(dirs, separator='/')
  dir1, dir2 = dirs.minmax.map{|dir| dir.split(separator)}
  dir1.zip(dir2).take_while{|dn1,dn2| dn1==dn2}.map(&:first).join(separator)
end

p common_directory_path(dirs)           #=> "/home/user1/tmp"
