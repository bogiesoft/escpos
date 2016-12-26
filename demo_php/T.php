<?php
	
// EPSON LX 300+II ( 9pin printer )



/* ASCII constants */
const ESC = "\\x1b";
const GS="\\x1d";
const NUL="\\\x00";


// Text = *3-2*	
// ESC (  B  11 1  5  3  0  90  0  1 
// 1B  28 42 0B 01 05 03 FE 5A 00 01   2A 33 2D 32 2A
//const BAR = "\x1B\x28\x42\x0B\x01\x05\x03\xFE\x5A\x00\x01\x2A\x33\x2D\x32\x2A";
ob_start(); // capture output

/* Output an example receipt */
echo ESC."@"; // Reset to defaults
//echo ESC."E".chr(1); // Bold
//echo ESC."F"; // Not Bold
echo ESC."A".chr(9); // Line spacing 0

echo ESC."A".chr(9);

?>
Я подтверждаю
<?php echo ESC."4"; // Italic ?>Я подтверждаю
<?php echo ESC."5"; // Cancel Italic ?>
<?php echo ESC."M"; // 12cpi ?>Я подтверждаю
<?php echo ESC."g"; // 15cpi ?>Я подтверждаю
<?php echo ESC."S";// Superscript mode ?>Я подтверждаю
<?php echo ESC."T";// Subscript mode ?>Я подтверждаю


<?php //echo printf("%-60s   %60s\n", "+774761514", ESC."E".chr(1)."ОСОБЫЕ ОТМЕТКИ".ESC."F"); ?>

<?
// outputing
// Characterset conversion
//$tpl = iconv("UTF-8","866",ob_get_clean());
$tpl = iconv("UTF-8","windows-1251",ob_get_clean());
// Magic transform escaped \\x to hex \x
$tpl = preg_replace('/(\\\\x)([0-9A-Fa-f]{1,2})/e','chr(0x$2)', $tpl);

echo $tpl.PHP_EOL;
exit(0);


<?php echo chr(14); // SO Double width ?>
<?php echo chr(20); // DC4 Cancel double width ?>



//------------------------------------------------------------------




function ech($text){
	//echo iconv("UTF-8", "CP1251//TRANSLIT//IGNORE", $text);
	echo iconv("UTF-8", "866", $text);	
	//echo $text;
}

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

