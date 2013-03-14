<?php

class jpush {


	// 测试
	private $_appkeys = '';
	private $_secrect = '';


	/**
	 * 构造函数
	 * @param string $username
	 * @param string $password
	 * @param string $appkeys
	 */
	function __construct() {
	}
	/**
	 * 模拟post进行url请求
	 * @param string $url
	 * @param string $param
	 */
	function request_post($url = '', $param = '') {
		if (empty($url) || empty($param)) {
			return false;
		}

		$postUrl = $url;
		$curlPost = $param;
		$ch = curl_init();//初始化curl
		curl_setopt($ch, CURLOPT_URL,$postUrl);//抓取指定网页
		curl_setopt($ch, CURLOPT_HEADER, 0);//设置header
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);//要求结果为字符串且输出到屏幕上
		curl_setopt($ch, CURLOPT_POST, 1);//post提交方式
		curl_setopt($ch, CURLOPT_POSTFIELDS, $curlPost);
		$data = curl_exec($ch);//运行curl
		curl_close($ch);

		return $data;
	}

	function send($sendno = 0, $receiver_type = 1, $receiver_value = '', $msg_type = 1, $msg_content = '', $platform = 'android') {
		$url = 'http://api.jpush.cn:8800/sendmsg/v2/sendmsg';

		$verification_code = strtoupper(md5($sendno.$receiver_type.$receiver_value.$this->_secrect));
		$param = [
			'sendno' => $sendno,
			'app_key' => $this->_appkeys,
			'receiver_type' => $receiver_type, // 1 IMEI
			'receiver_value' => $receiver_value,
			'verification_code' => $verification_code,

			'msg_type' => $msg_type,
			'msg_content' => $msg_content,
			'platform' => $platform,
		];

		$paramString = http_build_query($param);

		print_r($param);

		$res = $this->request_post($url, $paramString);
		if ($res === false) {
			return false;
		}
		$res_arr = json_decode($res, true);

		return $res_arr;
	}

}

$sendno = 1;
$receiver_value = ''; // imei
//$msg_content = json_encode(array('n_builder_id'=>0, 'n_title'=>'title test', 'n_content'=>'hello friend2222!'));

$aContent = [
	'n_content' => 'x.tao 回应了你发布的 在 沿途随拍 相册中的照片',
	'n_extras' => [
		'type' => 'feed',
		'feed' => ['id' => 111],
		'user' => ['id' => 222],
	],
];
$msg_content = json_encode($aContent);

$platform = 'android';

$obj = new jpush();
$res = $obj->send($sendno, 1, $receiver_value, 1, $msg_content, $platform);
var_dump($msg_content);
print_r($res);
exit();
