<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:date="http://exslt.org/dates-and-times" xmlns:exslt="http://exslt.org/common" xmlns:c="c" exclude-result-prefixes="exslt c date">
	
<xsl:output method="text" encoding="utf-8" omit-xml-declaration="yes" indent="no"/>
<!--xsl:strip-space elements="receipt div" /-->
<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="pre" />

<xsl:variable name="WIDTH" select="/page/@width"/>


<xsl:variable name="ESC" select="'\x1b'"/>
<xsl:variable name="GS" select="'\x1d'"/>
<xsl:variable name="NUL" select="'\x00'"/>

<!-- # Feed control sequences -->
<xsl:variable name="CTL_LF" select="'\x0a'"/> <!-- Print and line feed -->
<xsl:variable name="CTL_FF" select="'\x0c'"/> <!-- Form feed -->
<xsl:variable name="CTL_CR" select="'\x0d'"/> <!-- Carriage return -->

<!-- # Printer hardware -->
<xsl:variable name="HW_INIT" select="'\x1b\x40'"/> <!-- Clear data in buffer and reset modes -->
<xsl:variable name="HW_SELECT" select="'\x1b\x3d\x01'"/> <!-- # Printer select -->
<xsl:variable name="HW_RESET" select="'\x1b\x3f\x0a\x00'"/> <!-- Reset printer hardware -->

<!-- # Text format -->
<xsl:variable name="TXT_NORMAL" select="'\x1b\x21\x00'"/> <!-- Normal text -->

<xsl:variable name="TXT_2HEIGHT" select="'\x1bw\x01'"/> <!-- Double height text -->
<xsl:variable name="TXT_2HEIGHT_CANCEL" select="'\x1bw\x00'"/> <!-- Double height text -->
<xsl:variable name="TXT_2WIDTH" select="'\x0E'"/> <!-- Double width text -->
<xsl:variable name="TXT_2WIDTH_CANCEL" select="'\x14'"/> <!-- Double width text -->
<xsl:variable name="TXT_DOUBLE" select="'\x1b\x77\x01\x0E'"/> <!-- Double height & Width -->
<xsl:variable name="TXT_DOUBLE_CANCEL" select="'\x1b\x77\x00\x14'"/> <!-- Double height & Width -->

<xsl:variable name="TXT_BOLD_ON" select="'\x1bE\x01'"/> <!-- Bold font ON -->
<xsl:variable name="TXT_BOLD_OFF" select="'\x1bF'"/> <!-- Bold font OFF -->

<xsl:variable name="TXT_FONT_BIG" select="'\x1bg'"/> <!-- Font type A -->
<xsl:variable name="TXT_FONT_BIG_CANCEL" select="'\x1bP'"/> <!-- Font type A -->
<xsl:variable name="TXT_FONT_SMALL" select="'\x1bM'"/> <!-- Font type B -->
<xsl:variable name="TXT_FONT_SMALL_CANCEL" select="'\x1bP'"/> <!-- Font type B -->

<xsl:variable name="TXT_ALIGN_LT" select="'\x1b\x61\x00'"/> <!-- Left justification -->
<xsl:variable name="TXT_ALIGN_CT" select="'\x1b\x61\x01'"/> <!-- Centering -->
<xsl:variable name="TXT_ALIGN_RT" select="'\x1b\x61\x02'"/> <!-- Right justification -->

<!-- # Barcod format -->
<xsl:variable name="BARCODE_CODE39" select="'\x1bU\x01\x1b(B'"/> <!-- Barcode type CODE39 -->


<!-- T E M P L A T E S -->

<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="/page">
<xsl:value-of select="$ESC"/>@
<xsl:apply-templates select="@*"/>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="b"><xsl:value-of select="$TXT_BOLD_ON"/><xsl:apply-templates/><xsl:value-of select="$TXT_BOLD_OFF"/></xsl:template>

<xsl:template match="left"><xsl:value-of select="$TXT_ALIGN_LT"/><xsl:apply-templates/></xsl:template>
<xsl:template match="center"><xsl:value-of select="$TXT_ALIGN_CT"/><xsl:apply-templates/><xsl:value-of select="$TXT_ALIGN_LT"/></xsl:template>
<xsl:template match="right"><xsl:value-of select="$TXT_ALIGN_RT"/><xsl:apply-templates/><xsl:value-of select="$TXT_ALIGN_LT"/></xsl:template>

<xsl:template match="em[@size='h']"><xsl:value-of select="$TXT_2HEIGHT"/><xsl:apply-templates/><xsl:value-of select="$TXT_2HEIGHT_CANCEL"/></xsl:template>
<xsl:template match="em[@size='w']"><xsl:value-of select="$TXT_2WIDTH"/><xsl:apply-templates/><xsl:value-of select="$TXT_2WIDTH_CANCEL"/></xsl:template>



<xsl:template match="em[@size='wh']"><xsl:value-of select="$TXT_DOUBLE"/><xsl:apply-templates/><xsl:value-of select="$TXT_DOUBLE_CANCEL"/></xsl:template>

<xsl:template match="small"><xsl:value-of select="$TXT_FONT_SMALL"/><xsl:apply-templates/><xsl:value-of select="$TXT_FONT_SMALL_CANCEL"/></xsl:template>
<xsl:template match="h15"><xsl:value-of select="$TXT_FONT_BIG"/><xsl:apply-templates/><xsl:value-of select="$TXT_FONT_BIG_CANCEL"/></xsl:template>
<xsl:template match="line"><xsl:value-of select="$ESC"/>A\x<xsl:call-template name="toHex"><xsl:with-param name="index"><xsl:value-of select="@height"/></xsl:with-param></xsl:call-template><xsl:apply-templates/><xsl:value-of select="$ESC"/>A\x09</xsl:template>


<xsl:template match="@line-height"><xsl:value-of select="$ESC"/>A\x<xsl:call-template name="toHex"/></xsl:template>
<xsl:template match="@margin-left"><xsl:value-of select="$ESC"/>l\x<xsl:call-template name="toHex"/></xsl:template>
<xsl:template match="@margin-right"><xsl:value-of select="$ESC"/>Q\x<xsl:call-template name="toHex"/></xsl:template>

<xsl:template match="@name"></xsl:template>


<xsl:template match="table">
    <xsl:for-each select="tr">
        <xsl:call-template name="sprintf">
            <xsl:with-param name="ltext" select="th"/>
            <xsl:with-param name="rtext" select="td"/>
        </xsl:call-template>
        <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>

    <xsl:for-each select="tc[1]/td">
        <xsl:variable name="pos" select="position()"/>
        <!--[[<xsl:value-of select="."/> <xsl:value-of select="../../tc[2]/td[$pos]"/>]] -->
        <xsl:call-template name="sprintf">
            <xsl:with-param name="ltext" select="."/>
            <xsl:with-param name="rtext" select="../../tc[2]/td[$pos]"/>
        </xsl:call-template>
        <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
</xsl:template>

<xsl:template match="tr">
    <xsl:call-template name="sprintf">
        <xsl:with-param name="ltext" select="th"/>
        <xsl:with-param name="rtext" select="td"/>
    </xsl:call-template>
    <xsl:text>&#xA;</xsl:text> 
</xsl:template>




<xsl:template match="text()" name="insertBreaks" mode="table">
   <xsl:param name="pText" select="."/>
   <xsl:choose>
     <xsl:when test="not(contains($pText, '&#xA;'))">
        <xsl:copy-of select="$pText"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:value-of select="substring-before($pText, '&#xA;')"/>
       <td>
           <xsl:call-template name="insertBreaks">
                <xsl:with-param name="pText" select="substring-after($pText, '&#xA;')"/>
           </xsl:call-template>
       </td>
     </xsl:otherwise>
   </xsl:choose>
</xsl:template>


<!--xsl:template match="*" mode="width">
  <xsl:param name="len" select="0"/>
  <xsl:apply-templates mode="width">
    <xsl:with-param name="len" select="$len + string-length(.)"/>
  </xsl:apply-templates>
 </xsl:template-->

<xsl:template match="text()" mode="width">
  <xsl:param name="len" select="0"/>
  <xsl:value-of select="$len+string-length(.)"/>
 </xsl:template>

<xsl:template name="sprintf">
   <xsl:param name="ltext"/>
   <xsl:param name="rtext"/>
   <xsl:param name="width" select="$WIDTH"/>

   <xsl:param name="sign" select="concat(@sign,substring(' ', 1 + 1*boolean(@sign)))"/> <!-- Default value magic :) -->

   <xsl:variable name="ltext_width"><xsl:apply-templates select="$ltext" mode="width"/></xsl:variable>
   <xsl:variable name="rtext_width"><xsl:apply-templates select="$rtext" mode="width"/></xsl:variable>

   <xsl:variable name="n_ltext_width">
        <xsl:choose>
            <xsl:when test="string-length($ltext_width) &gt; 0"><xsl:value-of select="$ltext_width"/></xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="n_rtext_width">
        <xsl:choose>
            <xsl:when test="string-length($rtext_width) &gt; 0"><xsl:value-of select="$rtext_width"/></xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

   <xsl:variable name="text_width" select="$width - $n_ltext_width - $n_rtext_width"/>

   <!--[<xsl:value-of select="$width"/>-<xsl:value-of select="$n_ltext_width"/>:<xsl:value-of select="$n_rtext_width"/>=<xsl:value-of select="$text_width"/>]-->

    <!--xsl:param name="width" select="$WIDTH - string-length($ltext) - concat(
        $rtext/@width,
        substring(
            string-length($rtext), 1 + string-length($rtext)*boolean($rtext/@width)
        ) 
    )"/-->

   <xsl:apply-templates select="$ltext"/>
   <!--[<xsl:value-of select="concat($rtext/@width,substring(string-length($rtext), 1 + 2*boolean($rtext/@width)))"/>]-->
   <xsl:call-template name="applyNTimes">
        <xsl:with-param name="pTimes" select="$text_width"/>
        <xsl:with-param name="pSign" select="$sign"/>
    </xsl:call-template>
    <xsl:apply-templates select="$rtext"/>
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

<!--
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
-->

<xsl:template match="barcode"><xsl:value-of select="$BARCODE_CODE39"/>\x<xsl:call-template name="toHex"><xsl:with-param name="index"><xsl:value-of select="6+string-length(.)"/></xsl:with-param></xsl:call-template>\x00\x05\x01\xFE\x14\x00\x02<xsl:value-of select="."/></xsl:template>

<xsl:template match="barcode" mode="width">
    <xsl:param name="len" select="0"/>
    <xsl:value-of select="$len + (4 * string-length(.))"/>
</xsl:template>

<xsl:template match="em[@size='w']" mode="width">
    <xsl:param name="len" select="0"/>
    <xsl:value-of select="$len + (2 * string-length(.))"/>
</xsl:template>

<xsl:template match="em[@size='h']" mode="width">
    <xsl:param name="len" select="0"/>
    <xsl:value-of select="$len + floor(1.8 * string-length(.))"/>
</xsl:template>

<xsl:template match="@*"></xsl:template><!--xsl:apply-templates/-->



<xsl:template name="toHex">
    <xsl:param name="index" select="." />
    <xsl:if test="$index > 0">
      <xsl:call-template name="toHex">
        <xsl:with-param name="index" select="floor($index div 16)" />
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="$index mod 16 &lt; 10">
          <xsl:value-of select="$index mod 16" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$index mod 16 = 10">A</xsl:when>
            <xsl:when test="$index mod 16 = 11">B</xsl:when>
            <xsl:when test="$index mod 16 = 12">C</xsl:when>
            <xsl:when test="$index mod 16 = 13">D</xsl:when>
            <xsl:when test="$index mod 16 = 14">E</xsl:when>
            <xsl:when test="$index mod 16 = 15">F</xsl:when>
            <xsl:otherwise>A</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>