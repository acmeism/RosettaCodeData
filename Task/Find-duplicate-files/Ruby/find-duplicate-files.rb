require 'digest/md5'

def find_duplicate_files(dir)
  puts "\nDirectory : #{dir}"
  Dir.chdir(dir) do
    file_size = Dir.foreach('.').select{|f| FileTest.file?(f)}.group_by{|f| File.size(f)}
    file_size.each do |size, files|
      next if files.size==1
      files.group_by{|f| Digest::MD5.file(f).to_s}.each do |md5,fs|
        next if fs.size==1
        puts "  --------------------------------------------"
        fs.each{|file| puts "  #{File.mtime(file)}  #{size}  #{file}"}
      end
    end
  end
end

find_duplicate_files("/Windows/System32")
