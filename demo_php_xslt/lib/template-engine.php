<?php


function render($tpl){

	$templateVars

	// Magic transform escaped \\x to hex \x	
	$tpl = preg_replace('/(\\\\x)([0-9A-Fa-f]{1,2})/e','chr(0x$2)', $tpl);
	return $tpl;

}

function ech($text){
	//echo iconv("UTF-8", "CP1251//TRANSLIT//IGNORE", $text);
	echo iconv("UTF-8", "866", $text);	
	//echo $text;
}

function transform_xml_file($xml,$xsl){
	$xslt = new xsltProcessor;
	
	$dom_xsl = new DOMDocument();
	$dom_xsl->load($xsl);
	
	try {
		$dom_xml = new DOMDocument();
		$dom_xml->load($xml);
	} catch(Exception $e){
		print "\n\n\n";
		print file_get_contents($xml);
		print "\n\n\n";
		throw $e;
	}
	
	$xslt->importStyleSheet($dom_xsl);
	return $xslt->transformToXML($dom_xml);
}


?>