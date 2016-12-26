<?php 

/* ASCII constants */
const ESC = "\\x1b";
const GS="\\x1d";
const NUL="\\\x00";

function template(){

}

function column($align){
	return "column";
}


function line($height){
	return "line";
}


$templateVars = array(
	"b" 		=> [ESC."E".chr(1),ESC."F"],
	"center"	=> [ESC."a".chr(1),ESC."a".chr(0)],
	"left"		=> [ESC."a".chr(0),ESC."a".chr(0)],
	"right"		=> [ESC."a".chr(2),ESC."a".chr(0)],
	"dw"		=> [chr(14),chr(20)],
	"dh"		=> [ESC."w".chr(1),ESC."w".chr(0)],
	"small"		=> [ESC."M",ESC."P"],
	"h15"		=> [ESC."g",ESC."P"],
	"template"	=> [ESC."@",ESC."@"],
	"line"		=> [ESC."A".chr(9),ESC."A".chr(9)],
	"col-left"	=> ["left","left"],
	"col-right"	=> ["right","right"],
	"barcode"	=> [barcode("TP123456789KZ"),""],
);



function barcode($text){
	
	$nl = chr(6 + strlen($text));
	$nh = chr(0);//6 + strlen($barcode);
	$k = chr(5); // 05-Code 39, 06-Code 128

	$m = chr(1); // Module Width, Default 2 !!! <WIDTH of BAR> minimum 1
	$s = "\\xFE";//chr(254); // Space Ajustment -3 0 3 ( 253 254 255 0 1 2 3 )
	$v1  = chr(20); // Bar length !!! <HEIGHT>
	$v2 = chr(0); // Bar length
	$c = chr(2); // Control Flag - 

	$ret = ESC."U".chr(1); // Set to unidirectional
	$ret .= ESC."("."B".$nl.$nh.$k.$m.$s.$v1.$v2.$c.$text."\n"; // Print barcode ESC ( B
	//$ret .= ESC."U".chr(0); // Reset to unidirectional
	
	return $ret;
}

?>