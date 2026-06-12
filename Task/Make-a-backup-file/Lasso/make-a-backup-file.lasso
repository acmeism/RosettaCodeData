local(file2use = 'input.txt')

// create file
// only need to do this if this code example has not been run before and input.txt foes not exist, else leave commented out
//local(nf = file(#file2use))
//#nf->doWithClose => { #nf->writeBytes('Hello, World!'->asBytes) }


// move file
local(f = file(#file2use))
local(contents_of_f = #f->readstring)
#f->moveTo(#file2use+'.bak')
#f->close

// make mods to file contents
#contents_of_f->append('\rLasso is awesome!')

// create new file with new contents
local(nf = file(#file2use))
#nf->doWithClose => { #nf->writeBytes(#contents_of_f->asBytes) }
