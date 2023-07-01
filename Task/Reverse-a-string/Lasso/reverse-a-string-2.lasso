local(input = 'asdf', output = array)
with i in #input->values
do #output->insertFirst(#i)
#output->join
