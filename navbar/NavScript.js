//*==============================================================================
//*    Helpware NavScript.js 1.01
//*      Copyright (c) 2008, Robert Chandler, The Helpware Group
//*      http://helpware.net/FAR/
//*      support@helpware.net
//*    Descriptions:
//*      Adds a Open Navigation link at page top if nav is currently not open
//*       or inside a CHM.
//*    Usage: Anyone may use and modify this file. If you modify it then
//*       please change its name and acknowledge my work in your (c) statement.
//*       Email me your changes if you think that others could benefit too.
//*==============================================================================
//*  10-June-2008: 1.00 RWC - Original Version
//*  11-July-2008: 1.01 RWC - Now detects if inside CHM Help file. IsInsideChm()
//*

function GetTest()
{
   alert( window.location );
}

function WriteOpenNavBar(navLink, prefix, curFileName)
{
  var ss = '<nav>'
          +'<section>'
          +'<div id="download-container"><a class="download" href="http://ahkscript.org/download/ahk-install.exe" title="Herunterladen und in Sekunden installieren">AutoHotkey herunterladen</a></div>'
          +'<ul>'
          +'<li><a href="'+prefix+'../download/index.htm">Downloads</a></li>'
          +'<li><a href="'+prefix+'AutoHotkey.htm">Dokumentation</a></li>'
          +'<li><a href="'+prefix+'Tutorial.htm">Tutorial</a></li>'
          +'<li><a href="http://ahkscript.org/boards/">Forum</a></li>'
          +'</ul>'
          +'</section>'
          +'</nav>'
          +'<div id="helpbar">'
          +'<section>'
          +'<a href="http://ahkscript.org/docs/'+curFileName+'" style="float: right;">Originalseite</a>'
          +'<a href="'+navLink+'">Navigationsleiste anzeigen</a>'
          +'</section>'
          +'</div>';
  document.write(ss);
}

function WriteOpenHelpBar(curFileName)
{
  var ss = '<div id="helpbar">'
          +'<section>'
          +'<a href="http://ahkscript.org/docs/'+curFileName+'" style="float: right;">Originalseite</a>'
          +'Permalink: <a href="http://ragnar-f.github.io/docs/'+curFileName+'">http://ragnar-f.github.io/docs/'+curFileName+'</a>'
          +'</section>'
          +'</div>';
  document.write(ss);
}

function WriteOpenHeader(navLink, prefix, curFileName)
{
  var ss = '<div id="top">'
          +'<section>'
          +'<div id="languages"><a href="http://ahkscript.org"><img src="'+prefix+'static/flags/en.png" alt="English" /></a>&nbsp;<a href="http://ahkcn.sourceforge.jp"><img src="'+prefix+'static/flags/cn.png" alt="Chinese" /></a></div>'
          +'<h1><a href="'+prefix+'../index.htm"><img src="'+prefix+'static/ahk_logo.png" width="518" height="81" alt="AutoHotkey" /></a></h1>'
          +'</section>'
          +'</div>';
  document.write(ss);
  WriteOpenNavBar(navLink, prefix, curFileName);
}

function WriteOpenFooter(prefix)
{
  var ss = '<div id="end">'
          +'<div id="footer">'
          +'<section>'
          +'<article id="os"><a href="'+prefix+'license.htm"><img src="'+prefix+'static/opensource-logo.png" width="90" height="77" alt="Open Source" /><br />'
          +'GNU General Public License</a></article>'
          +'<article>'
          +'<h4>Community-Foren</h4>'
          +'<ul>'
          +'<li><a href="http://ahkscript.org/boards/viewforum.php?f=9">Support</a></li>'
          +'<li><a href="http://ahkscript.org/boards/viewforum.php?f=10">Scripts</a></li>'
          +'<li><a href="http://ahkscript.org/boards/viewforum.php?f=13">Vorschl&auml;ge</a></li>'
          +'<li><a href="http://ahkscript.org/boards/viewforum.php?f=24">Ank&uuml;ndigungen</a></li>'
          +'</ul>'
          +'</article>'
          +'<article>'
          +'<h4>Dokumentation</h4>'
          +'<ul>'
          +'<li><a href="'+prefix+'AutoHotkey.htm">Index</a></li>'
          +'<li><a href="'+prefix+'Tutorial.htm">Tutorial</a></li>'
          +'<li><a href="'+prefix+'FAQ.htm">FAQ</a></li>'
          +'<li><a href="'+prefix+'commands/index.htm">Referenz</a></li>'
          +'</ul>'
          +'</article>'
          +'<article>'
          +'<h4>Ressourcen</h4>'
          +'<ul>'
          +'<li><a href="'+prefix+'../download/index.htm">Downloads</a></li>'
          +'<li><a href="'+prefix+'AHKL_ChangeLog.htm">Changelog</a></li>'
          +'<li><a href="https://github.com/Lexikos/AutoHotkey_L">Quellcode</a></li>'
          +'<li><a href="'+prefix+'../support/index.htm">Kontakt</a></li>'
          +'</ul>'
          +'</article>'
          +'<article id="search">'
          +'<form method="get" action="http://www.google.de/search">'
          +'<table>'
          +'<tr>'
          +'<td colspan="2"><input id="q" name="q" size="30" value="" type="text"></td>'
          +'</tr>'
          +'<tr>'
          +'<td><select name="sitesearch">'
          +'<option value="ragnar-f.github.io" selected="selected">Alles</option>'
          +'<option value="ragnar-f.github.io/docs">Dokumentation</option>'
          +'<option value="www.ahkscript.org/boards">Forum</option>'
          +'</select></td>'
          +'<td style="text-align: right;"><input value="Suchen" type="submit"></td>'
          +'</tr>'
          +'</table>'
          +'</form>'
          +'</article>'
          +'<div class="clear"></div>'
          +'</section>'
          +'</div>'
          +'<div id="copyright">'
          +'<section>Copyright &copy; 2004 - 2012 Chris Mallet</section>'
          +'</div>'  
          +'</div>';
  document.write(ss);
}

function IsNavOpen()
{
  if ((top.right == null) || (top.right == undefined) || (top.right.location == null) || (top.right.location == undefined) || (typeof(top.right.location.href) != "string") || (top.right.location.href == ""))
    return false;  //no nav found
  else
    return true;  //nav found
}

function IsInsideChm() //returns true if current file is inside a CHM Help File
{
  var ra = /::/;
  return (location.href.search(ra) > 0); //If found then then we are in a CHM
}

function GetInfos(aDirLevel)
{
    var prefix = "";
    for (var n=0; n < aDirLevel; n++)
      prefix = prefix + "../";

    //find last back slash in path
    var x = location.href.lastIndexOf("/");       // get last splash of "path/dir/name.htm"
    for (var n=0; n < aDirLevel; n++)
      x = location.href.lastIndexOf("/", x-1);    // get 2nd last slash etc
    var curFileName = location.href.substr(x+1);
    var navLink = prefix + "goto.htm#" + curFileName
    return {navLink:navLink,prefix:prefix,curFileName:curFileName};

}
// pass in the directory level. 0 = if this HTML is same level as hh_goto.hh; 1 = of one level down etc
function WriteNavBar(aDirLevel)
{
  if ((!IsNavOpen()) && (!IsInsideChm()))
  {
    var g = GetInfos(aDirLevel);
    WriteOpenNavBar(g.navLink, g.prefix, g.curFileName);
  }
}

function WriteHelpBar(aDirLevel)
{
  if ((IsNavOpen()) || (IsInsideChm()))
  {
    var g = GetInfos(aDirLevel);
    WriteOpenHelpBar(g.curFileName);
  }
}

function WriteHeader(aDirLevel)
{
  var g = GetInfos(aDirLevel);
  if ((!IsNavOpen()) && (!IsInsideChm()))
    WriteOpenHeader(g.navLink, g.prefix, g.curFileName);
  else
    WriteOpenHelpBar(g.curFileName);
}

function WriteFooter(aDirLevel)
{
  if ((!IsNavOpen()) && (!IsInsideChm()))
  {
    var prefix = "";
    for (var n=0; n < aDirLevel; n++)
      prefix = prefix + "../";
    WriteOpenFooter(prefix);
  }
}




