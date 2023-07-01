local(a = array('UK'='London','US'='New York','US'='Birmingham','UK'='Birmingham'))
with i in #a order by #i->second, #i->first do => {^ #i->first+' - '+#i->second+'\r' ^}
