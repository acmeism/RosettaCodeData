link printf,strings

procedure main()
YS := YahooSearch("rosettacode")
every 1 to 2 do {   # 2 pages
   YS.readnext()
   YS.showinfo()
   }
end

class YahooSearch(urlpat,page,response)  #: class for Yahoo Search

   method readnext()    #: read the next page of search results
      self.page +:= 1   # can't find as w|w/o self
      readurl()
   end

   method readurl()     #: read the url
      url := sprintf(self.urlpat,(self.page-1)*10+1)
      m := open(url,"m")  | stop("Unable to open : ",url)
      every (self.response := "") ||:= |read(m)
      close(m)
      self.response := deletec(self.response,"\x00") # kill stray NULs
   end

   method showinfo()    #: show the info of interest
      self.response ? repeat {
         (tab(find("<")) & ="<a class=\"yschttl spt\" href=\"") | break
         url   := tab(find("\"")) & tab(find(">")+1)
         title := tab(find("<")) & ="</a></h3></div>"
         tab(find("<")) & =("<div class=\"abstr\">" | "<div class=\"sm-abs\">")
         abstr := tab(find("<")) & ="</div>"

         printf("\nTitle : %i\n",title)
         printf("URL   : %i\n",url)
         printf("Abstr : %i\n",abstr)
         }
   end

initially(searchtext)    #: initialize each instance
   urlpat := sprintf("http://search.yahoo.com/search?p=%s&b=%%d",searchtext)
   page := 0
end
