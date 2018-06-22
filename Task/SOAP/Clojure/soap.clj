(require '[clj-soap.core :as soap])

(let [client (soap/client-fn "http://example.com/soap/wsdl")]
  (client :soapFunc)
  (client :anotherSoapFunc))
