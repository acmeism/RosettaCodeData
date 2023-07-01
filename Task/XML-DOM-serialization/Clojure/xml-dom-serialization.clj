(require '[clojure.data.xml :as xml])

(def xml-example (xml/element :root {} (xml/element :element {} "Some text here")))

(with-open [out-file (java.io.OutputStreamWriter.
                        (java.io.FileOutputStream. "/tmp/output.xml") "UTF-8")]
  (xml/emit xml-example out-file))
