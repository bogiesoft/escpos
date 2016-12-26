<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(0);

//$tpl = file_get_contents('http://print.smartpos.io/v1/escposxml/template/lotusthaispa.xhtml');
$tpl = transform_xml_file('E1.xml','xsl/escpos_p.xsl');

// encoding
$tpl = iconv("UTF-8", "866",$tpl);

// Magic transform escaped \\x to hex \x
$tpl = preg_replace('/(\\\\x)([0-9A-Fa-f]{1,2})/e','chr(0x$2)', $tpl);

// outputing
echo $tpl;




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

