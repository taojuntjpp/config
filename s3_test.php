<?php
set_time_limit(0);
date_default_timezone_set('Asia/Shanghai');

$startTime = time();

define('CRON_PATH', __DIR__);
define('APP_PATH', dirname(CRON_PATH));
define('CONFIG_PATH', APP_PATH.'/config');
define('PUBLIC_PATH', APP_PATH.'/public');
define('LIBRARY_PATH', APP_PATH.'/library');
define('VENDOR_PATH', APP_PATH.'/vendor');


require_once PUBLIC_PATH.'/init_autoloader.php';

$config_arr = require_once CONFIG_PATH.'/juwai.config.php';

$JW_AWS = new JuWai\JwAws($config_arr['aws']);
var_dump($JW_AWS->listByBucket('juwai-test'));
exit;
$files = glob(PUBLIC_PATH.'/images/*[jpg|png]');
shuffle($files);
$file = array_pop($files);
$result = $JW_AWS->uploadBybucket('juwai-test', $file, 'test/');

var_dump($result);


var_dump($JW_AWS->listByBucket('juwai-test'));

exit;
