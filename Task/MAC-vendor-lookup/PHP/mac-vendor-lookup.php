<?php
$apiRoot = "https://api.macvendors.com";
$macList = array("88:53:2E:67:07:BE", "D4:F4:6F:C9:EF:8D",
		 "FC:FB:FB:01:FA:21", "4c:72:b9:56:fe:bc", "00-14-22-01-23-45");

$curl = curl_init();
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
foreach ($macList as $burger) {
  curl_setopt($curl, CURLOPT_URL, "$apiRoot/$burger");
  echo(curl_exec($curl));
  echo("\n");
  sleep(2);
}
curl_close($curl);
?>
