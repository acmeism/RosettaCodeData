/* distributed_programming_client.wren */

import "./fmt" for Fmt

foreign class Client {
    construct dialHTTP(network, address) {}

    foreign call(serviceMethod, arg)
}

var client = Client.dialHTTP("tcp", "localhost:1234")
var amounts = [3, 5.6]
for (amount in amounts) {
    var tax = client.call("TaxComputer.Tax", amount)
    Fmt.print("Tax on $0.2f = $0.2f", amount, tax)
}
