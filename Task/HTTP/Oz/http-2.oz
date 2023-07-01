declare
  [HTTPClient] = {Module.link ['x-ozlib://mesaros/net/HTTPClient.ozf']}

  fun {GetPage Url}
     Client = {New HTTPClient.urlGET
	       init(inPrms(toFile:false toStrm:true)
		    httpReqPrms
		   )}
     OutParams
     HttpResponseParams
  in
     {Client getService(Url ?OutParams ?HttpResponseParams)}
     {Client closeAll(true)}
     OutParams.sOut
  end
in
  {System.showInfo {GetPage "http://www.rosettacode.org"}}
