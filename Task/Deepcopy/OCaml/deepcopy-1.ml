let rec copy t =
  if Obj.is_int t then t else
    let tag = Obj.tag t in
    if tag = Obj.double_tag then t else
    if tag = Obj.closure_tag then t else
    if tag = Obj.string_tag then Obj.repr (String.copy (Obj.obj t)) else
    if tag = 0 || tag = Obj.double_array_tag then begin
      let size = Obj.size t in
      let r = Obj.new_block tag size in
      for i = 0 to pred size do
        Obj.set_field r i (copy (Obj.field t i))
      done;
      r
    end else failwith "copy" ;;

let copy (v : 'a) : 'a = Obj.obj (copy (Obj.repr v))
