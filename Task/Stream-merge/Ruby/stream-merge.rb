def stream_merge(*files)
  fio = files.map{|fname| open(fname)}
  merge(fio.map{|io| [io, io.gets]})
end

def merge(fdata)
  until fdata.empty?
    io, min = fdata.min_by{|_,data| data}
    puts min
    if (next_data = io.gets).nil?
      io.close
      fdata.delete([io, min])
    else
      i = fdata.index{|x,_| x == io}
      fdata[i] = [io, next_data]
    end
  end
end

files = %w(temp1.dat temp2.dat temp3.dat)
files.each do |fname|
  data = IO.read(fname).gsub("\n", " ")
  puts "#{fname}: #{data}"
end
stream_merge(*files)
