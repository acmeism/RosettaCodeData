# #directory "+xml-light" (* or maybe "+site-lib/xml-light" *) ;;

# #load "xml-light.cma" ;;

# let data = [
    ("April", "Bubbly: I'm > Tam and <= Emily");
    ("Tam O'Shanter", "Burns: \"When chapman billies leave the street ...\"");
    ("Emily", "Short & shrift");
  ] in
  let tags =
    List.map (fun (name, comment) ->
      Xml.Element ("Character", [("name", name)], [(Xml.PCData comment)])
    ) data
  in
  print_endline (
    Xml.to_string_fmt (Xml.Element ("CharacterRemarks", [], tags)))
  ;;
<CharacterRemarks>
  <Character name="April">Bubbly: I&apos;m &gt; Tam and &lt;= Emily</Character>
  <Character name="Tam O'Shanter">Burns: &quot;When chapman billies leave the street ...&quot;</Character>
  <Character name="Emily">Short &amp; shrift</Character>
</CharacterRemarks>
- : unit = ()
