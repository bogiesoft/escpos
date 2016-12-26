<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:date="http://exslt.org/dates-and-times" xmlns:exslt="http://exslt.org/common" xmlns:c="c" exclude-result-prefixes="exslt c date">
	
<!--xsl:output method="text" encoding="windows-1251" omit-xml-declaration="yes" indent="no"/-->
<xsl:output method="text" encoding="windows-1251" omit-xml-declaration="yes" indent="no"/>
<!--xsl:strip-space elements="receipt div" /-->
<xsl:preserve-space elements="*" />

<xsl:variable name="WIDTH" select="/receipt/@width"/>

<xsl:variable name="ESC" select="'\x1b'"/>
<xsl:variable name="GS" select="'\x1d'"/>
<xsl:variable name="NUL" select="'\x00'"/>

<!-- # Feed control sequences -->
<xsl:variable name="CTL_LF" select="'\x0a'"/> <!-- Print and line feed -->
<xsl:variable name="CTL_FF" select="'\x0c'"/> <!-- Form feed -->
<xsl:variable name="CTL_CR" select="'\x0d'"/> <!-- Carriage return -->
<xsl:variable name="CTL_HT" select="'\x09'"/> <!-- Horizontal tab -->
<xsl:variable name="CTL_VT" select="'\x0b'"/> <!-- Vertical tab -->

<!-- # RT Status commands -->
<xsl:variable name="DLE_EOT_PRINTER" select="'\x10\x04\x01'"/> <!--# Transmit printer status -->
<xsl:variable name="DLE_EOT_OFFLINE" select="'\x10\x04\x02'"/>
<xsl:variable name="DLE_EOT_ERROR" select="'\x10\x04\x03'"/>
<xsl:variable name="DLE_EOT_PAPER" select="'\x10\x04\x04'"/>

<!-- # Printer hardware -->
<xsl:variable name="HW_INIT" select="'\x1b\x40'"/> <!-- Clear data in buffer and reset modes -->
<xsl:variable name="HW_SELECT" select="'\x1b\x3d\x01'"/> <!-- # Printer select -->
<xsl:variable name="HW_RESET" select="'\x1b\x3f\x0a\x00'"/> <!-- Reset printer hardware -->

<!-- # Cash Drawer -->
<xsl:variable name="CD_KICK_2" select="'\x1b\x70\x00'"/> <!-- # Sends a pulse to pin 2 []  -->
<xsl:variable name="CD_KICK_5" select="'\x1b\x70\x01'"/> <!-- # Sends a pulse to pin 5 []  -->

<!-- # Paper -->
<xsl:variable name="PAPER_FULL_CUT" select="'\x1d\x56\x00'"/> <!-- Full cut paper -->
<xsl:variable name="PAPER_PART_CUT" select="'\x1d\x56\x01'"/> <!-- Partial cut paper -->
<xsl:variable name="SHEET_SLIP_MODE" select="'\x1B\x63\x30\x04'"/> <!-- Print ticket on injet slip paper -->
<xsl:variable name="SHEET_ROLL_MODE" select="'\x1B\x63\x30\x01'"/> <!-- Print ticket on paper roll  -->

<!-- # Text format -->
<xsl:variable name="TXT_NORMAL" select="'\x1b\x21\x00'"/> <!-- Normal text -->
<xsl:variable name="TXT_2HEIGHT" select="'\x1b\x21\x10'"/> <!-- Double height text -->
<xsl:variable name="TXT_2WIDTH" select="'\x1b\x21\x20'"/> <!-- Double width text -->
<xsl:variable name="TXT_DOUBLE" select="'\x1b\x21\x30'"/> <!-- Double height & Width -->
<xsl:variable name="TXT_UNDERL_OFF" select="'\x1b\x2d\x00'"/> <!-- Underline font OFF -->
<xsl:variable name="TXT_UNDERL_ON" select="'\x1b\x2d\x01'"/> <!-- Underline font 1-dot ON -->
<xsl:variable name="TXT_UNDERL2_ON" select="'\x1b\x2d\x02'"/> <!-- Underline font 2-dot ON -->
<xsl:variable name="TXT_BOLD_OFF" select="'\x1b\x45\x00'"/> <!-- Bold font OFF -->
<xsl:variable name="TXT_BOLD_ON" select="'\x1b\x45\x01'"/> <!-- Bold font ON -->
<xsl:variable name="TXT_FONT_A" select="'\x1b\x4d\x00'"/> <!-- Font type A -->
<xsl:variable name="TXT_FONT_B" select="'\x1b\x4d\x01'"/> <!-- Font type B -->
<xsl:variable name="TXT_ALIGN_LT" select="'\x1b\x61\x00'"/> <!-- Left justification -->
<xsl:variable name="TXT_ALIGN_CT" select="'\x1b\x61\x01'"/> <!-- Centering -->
<xsl:variable name="TXT_ALIGN_RT" select="'\x1b\x61\x02'"/> <!-- Right justification -->
<xsl:variable name="TXT_COLOR_BLACK" select="'\x1b\x72\x00'"/> <!-- Default Color -->
<xsl:variable name="TXT_COLOR_RED" select="'\x1b\x72\x01'"/> <!-- Alternative Color ( Usually Red )  -->

<!--
# Barcod format
BARCODE_TXT_OFF = '\x1d\x48\x00' # HRI barcode chars OFF
BARCODE_TXT_ABV = '\x1d\x48\x01' # HRI barcode chars above
BARCODE_TXT_BLW = '\x1d\x48\x02' # HRI barcode chars below
BARCODE_TXT_BTH = '\x1d\x48\x03' # HRI barcode chars both above and below
BARCODE_FONT_A  = '\x1d\x66\x00' # Font type A for HRI barcode chars
BARCODE_FONT_B  = '\x1d\x66\x01' # Font type B for HRI barcode chars
BARCODE_HEIGHT  = '\x1d\x68\x64' # Barcode Height [1-255]
BARCODE_WIDTH   = '\x1d\x77\x03' # Barcode Width  [2-6]
BARCODE_UPC_A   = '\x1d\x6b\x00' # Barcode type UPC-A
BARCODE_UPC_E   = '\x1d\x6b\x01' # Barcode type UPC-E
BARCODE_EAN13   = '\x1d\x6b\x02' # Barcode type EAN13
BARCODE_EAN8    = '\x1d\x6b\x03' # Barcode type EAN8-->
<xsl:variable name="BARCODE_CODE39" select="'\x1d\x6b\x04'"/> <!-- Barcode type CODE39 -->
<!--BARCODE_ITF     = '\x1d\x6b\x05' # Barcode type ITF
BARCODE_NW7     = '\x1d\x6b\x06' # Barcode type NW7
# Image format  
S_RASTER_N      = '\x1d\x76\x30\x00' # Set raster image normal size
S_RASTER_2W     = '\x1d\x76\x30\x01' # Set raster image double width
S_RASTER_2H     = '\x1d\x76\x30\x02' # Set raster image double height
S_RASTER_Q      = '\x1d\x76\x30\x03' # Set raster image quadruple
-->


<!-- T E M P L A T E S -->

<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="/receipt">
<xsl:value-of select="$ESC"/>@<xsl:call-template name="encoding"/><xsl:text>&#xD;</xsl:text>
<xsl:apply-templates select="@font"/><xsl:apply-templates/>
</xsl:template>
<!--xsl:value-of select="$ESC"/>M\x00<xsl:value-of select="$ESC"/>!\x00 -->
<!--xsl:value-of select="$TXT_FONT_B"/><xsl:text>&#xA;</xsl:text-->



<xsl:template match="div"><xsl:apply-templates/><xsl:value-of select="$ESC"/>a\x00<xsl:text>&#xA;</xsl:text></xsl:template>

<xsl:template match="center"><xsl:value-of select="$ESC"/>a\x01<xsl:apply-templates/><xsl:value-of select="$ESC"/>a\x00</xsl:template>
<xsl:template match="left"><xsl:value-of select="$ESC"/>a\x00<xsl:apply-templates/></xsl:template>

<xsl:template match="right"><xsl:value-of select="$ESC"/>a\x02<xsl:apply-templates/><xsl:text>&#xD;</xsl:text><xsl:value-of select="$ESC"/>a\x00</xsl:template>

<xsl:template match="b"><xsl:value-of select="$ESC"/>E\x01<xsl:apply-templates/><xsl:value-of select="$ESC"/>E\x00</xsl:template>
<xsl:template match="em"><xsl:value-of select="$ESC"/>!\x16<xsl:apply-templates/><xsl:value-of select="$ESC"/>!\x00<xsl:call-template name="emFontIssue"/></xsl:template>
<xsl:template match="em[@size='w']"><xsl:value-of select="$TXT_2WIDTH"/><xsl:apply-templates/><xsl:value-of select="$ESC"/>!\x00<xsl:call-template name="emFontIssue"/></xsl:template>
<xsl:template match="em[@size='wh']"><xsl:value-of select="$TXT_DOUBLE"/><xsl:apply-templates/><xsl:value-of select="$ESC"/>!\x00<xsl:call-template name="emFontIssue"/></xsl:template>

<xsl:template match="@font"><xsl:call-template name="handlefont"><xsl:with-param name="size" select="."/></xsl:call-template></xsl:template>
<xsl:template match="font"><xsl:call-template name="handlefont"/><xsl:apply-templates/><xsl:value-of select="$ESC"/>M\x00<xsl:text>&#xA;</xsl:text></xsl:template>

<xsl:template match="br">
<xsl:param name="lines" select="concat(@lines,substring('1', 1 + 1*boolean(@lines)))"/> <!-- Default value magic :) -->
<xsl:value-of select="$ESC"/>d\x0<xsl:value-of select="$lines"/>
</xsl:template>

<!--xsl:template match="barcode"><xsl:value-of select="$BARCODE_CODE39"/><xsl:value-of select="."/><xsl:value-of select="$NUL"/><xsl:text>&#xA;</xsl:text></xsl:template -->
<!-- barcode height, barcode label, barcode -->
<xsl:template match="barcode">\x1d\x68\x32<xsl:value-of select="$GS"/>H\x00<xsl:value-of select="$GS"/>k\x04<xsl:value-of select="."/><xsl:value-of select="$NUL"/></xsl:template>

<xsl:template match="hr">
<xsl:param name="width" select="$WIDTH - string-length(.)"/>
<xsl:param name="sign" select="concat(@sign,substring('—', 1 + 1*boolean(@sign)))"/> <!-- Default value magic :) -->
<xsl:value-of select="."/>
<xsl:call-template name="applyNTimes">
    <xsl:with-param name="pTimes" select="$width"/>
    <xsl:with-param name="pSign" select="$sign"/>
</xsl:call-template>
<xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="applyNTimes">
<xsl:param name="pTimes" select="0"/>
<xsl:param name="pPosition" select="1"/>
<xsl:param name="pSign"/>

<xsl:if test="$pTimes > 0">
    <xsl:value-of select="$pSign"/>
    <xsl:call-template name="applyNTimes">
        <xsl:with-param name="pTimes" select="$pTimes -1"/>
        <xsl:with-param name="pPosition" select="$pPosition+1"/>
        <xsl:with-param name="pSign" select="$pSign"/>
     </xsl:call-template>
</xsl:if>
</xsl:template>

<xsl:template match="cut">
<xsl:param name="mode" select="'41'"/><!-- FULL=00/41 or PARTIAL=01/42 -->
<xsl:param name="feed" select="'00'"/><!-- Lines to feed-->
<xsl:value-of select="$GS"/>V\x<xsl:value-of select="$mode"/>\x<xsl:value-of select="$feed"/>
</xsl:template>

<xsl:template match="cashdraw">
<xsl:param name="pin" select="'00'"/><!-- PIN2=00 or PIN5=01 -->
<xsl:value-of select="$ESC"/>p\x<xsl:value-of select="$pin"/><xsl:text>&#xA;</xsl:text>
</xsl:template>

	
<xsl:template name="encoding"><xsl:if test="not(@encoding='')"><xsl:value-of select="$ESC"/>t\x06</xsl:if></xsl:template> <!-- windows-1251 -->

<xsl:template name="emFontIssue"><xsl:for-each select="ancestor::*[@font][position() = 1]"><xsl:call-template name="handlefont"><xsl:with-param name="size" select="@font"/></xsl:call-template></xsl:for-each></xsl:template>

<xsl:template name="handlefont">
<xsl:param name="size" select="@size"/>
<xsl:value-of select="$ESC"/>M<xsl:choose><xsl:when test="$size='B'">\x01</xsl:when><xsl:when test="$size='C'">\x02</xsl:when><xsl:otherwise>\x00</xsl:otherwise></xsl:choose>
</xsl:template>

<!--xsl:template match="@*"></xsl:template-->

</xsl:stylesheet>