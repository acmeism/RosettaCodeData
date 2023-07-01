wrap_mylib.o: wrap_mylib.c
        ocamlc -c -ccopt -I/usr/include/mylib $<

dllmylib_stubs.so: wrap_mylib.o
        ocamlmklib -o mylib_stubs $< -lmylib

mylib.mli: mylib.ml
        ocamlc -i $< > $@

mylib.cmi: mylib.mli
        ocamlc -c $<

mylib.cmo: mylib.ml mylib.cmi
        ocamlc -c $<

mylib.cma: mylib.cmo dllmylib_stubs.so
        ocamlc -a -o $@ $< -dllib -lmylib_stubs -cclib -lmylib

mylib.cmx: mylib.ml mylib.cmi
        ocamlopt -c $<

mylib.cmxa: mylib.cmx dllmylib_stubs.so
        ocamlopt -a -o $@ $< -cclib -lmylib_stubs -cclib -lmylib

clean:
        rm -f *.[oa] *.so *.cm[ixoa] *.cmxa
