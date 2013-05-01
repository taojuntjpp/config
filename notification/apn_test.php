<?php
$deviceToken = "";
$deviceToken = preg_replace("/[^0-9A-Fa-f]/", "", $deviceToken);

$apnsHost = 'gateway.push.apple.com';
$apnsPort = 2195;
$apnsCert = __DIR__.'/app/config/zuo_apn.pem';
//echo $apnsCert."\n";exit;

$streamContext = stream_context_create();
stream_context_set_option($streamContext, 'ssl', 'local_cert', $apnsCert);
stream_context_set_option($streamContext, "ssl", "passphrase", 'zaq1xsw2');
$apns = stream_socket_client('ssl://'.$apnsHost.':'.$apnsPort, $error, $errorString, 60, STREAM_CLIENT_CONNECT, $streamContext);

var_dump('ssl://'.$apnsHost.':'.$apnsPort);
var_dump($error);
var_dump($errorString);
//var_dump($streamContext);
//stream_socket_client($apnURL, $err, $errstr, 60, STREAM_CLIENT_CONNECT, $ctx);



$payload['aps'] = array('alert' => 'This is the alert text');
$payload = json_encode($payload, JSON_FORCE_OBJECT);
//echo $payload."\n";exit;


$apnsMessage1 = chr(0) . chr(0) . chr(32) . pack('H*', $deviceToken) . chr(0) . chr(strlen($payload)) . $payload;
//var_dump($apnsMessage1);
$apnsMessage = chr(1) . pack("N", 1) . pack("N", 0) . pack("n", 32) . pack("H*", $deviceToken) . pack("n", strlen($payload)) . $payload;
var_dump($apnsMessage);
//fwrite($apns, $apnsMessage1);
fwrite($apns, $apnsMessage);
fclose($apns);
