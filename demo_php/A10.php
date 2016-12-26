<?php
/* ASCII constants */
const ESC = "\x1b";
const GS="\x1d";
const NUL="\x00";
 
/* Output an example receipt */
echo ESC."@"; // Reset to defaults
echo ESC."E".chr(1); // Bold
echo "FOO CORP Ltd.\n"; // Company
echo ESC."E".chr(0); // Not Bold
echo ESC."d".chr(1); // Blank line
echo iconv("UTF-8","windows-1251","---- Привет Мир!");
echo ESC."d".chr(4); // 4 Blank lines

echo GS."V\x41".chr(3); // Cut
exit(0);

?>