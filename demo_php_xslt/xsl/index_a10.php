<?php
	header('Content-Type: text/plain; charset=windows-1251');

	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);

	//$tpl = file_get_contents('http://print.smartpos.io/v1/escposxml/template/lotusthaispa.xhtml');
	$tpl = transform_xml_file('template/lotusthaispa.xhtml','escpos_a10.xsl');
	#echo $tpl;	return;
	
	// Magic transform escaped \\x to hex \x
	$tpl = preg_replace('/(\\\\x)([0-9A-Fa-f]{1,2})/e','chr(0x$2)', $tpl);
	
	// P R O X Y - отправляем все в сокет
	if(isset($_SERVER["REMOTE_ADDR"])) // если reply 
		socket_put_contents($_SERVER["REMOTE_ADDR"],9100,$tpl);
	else // дефолт отправляем все на домашний принтер 
		socket_put_contents('pos.smartpos.kz',9100,$tpl);

	echo "OK to".$_SERVER["REMOTE_ADDR"];
	
?>
