class
  APPLICATION

create
  make

feature {NONE}

  make
    local
      test: LINKED_LIST [INTEGER]
    do
      create test.make
      test := compress ("TOBEORNOTTOBEORTOBEORNOT")
      across
        test as t
      loop
        io.put_string (t.item.out + " ")
      end
      io.new_line
      io.put_string (decompress (test))
    end

  decompress (compressed: LINKED_LIST [INTEGER]): STRING
      --Decompressed version of 'compressed'.
    local
      dictsize, i, k: INTEGER
      dictionary: HASH_TABLE [STRING, INTEGER]
      w, entry: STRING
      char: CHARACTER_8
    do
      dictsize := 256
      create dictionary.make (300)
      create entry.make_empty
      create Result.make_empty
      from
        i := 0
      until
        i > 256
      loop
        char := i.to_character_8
        dictionary.put (char.out, i)
        i := i + 1
      end
      w := compressed.first.to_character_8.out
      compressed.go_i_th (1)
      compressed.remove
      Result := w
      from
        k := 1
      until
        k > compressed.count
      loop
        if attached dictionary.at (compressed [k]) as ata then
          entry := ata
        elseif compressed [k] = dictsize then
          entry := w + w.at (1).out
        else
          io.put_string ("EXEPTION")
        end
        Result := Result + entry
        dictsize := dictsize + 1
        dictionary.put (w + entry.at (1).out, dictsize)
        w := entry
        k := k + 1
      end
    end

  compress (uncompressed: STRING): LINKED_LIST [INTEGER]
      -- Compressed version of 'uncompressed'.
    local
      dictsize: INTEGER
      dictionary: HASH_TABLE [INTEGER, STRING]
      i: INTEGER
      w, wc: STRING
      char: CHARACTER_8
    do
      dictsize := 256
      create dictionary.make (256)
      create w.make_empty
      from
        i := 0
      until
        i > 256
      loop
        char := i.to_character_8
        dictionary.put (i, char.out)
        i := i + 1
      end
      create Result.make
      from
        i := 1
      until
        i > uncompressed.count
      loop
        wc := w + uncompressed [i].out
        if dictionary.has (wc) then
          w := wc
        else
          Result.extend (dictionary.at (w))
          dictSize := dictSize + 1
          dictionary.put (dictSize, wc)
          w := "" + uncompressed [i].out
        end
        i := i + 1
      end
      if w.count > 0 then
        Result.extend (dictionary.at (w))
      end
    end

end
