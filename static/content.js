$(document).ready(function() {

  //
  // Check if website is inside a CHM file
  //

  if (location.href.search(/::/) > 0)
    return 0;

  //
  // Build website structure
  //

  var virtualDir = "";

  var urlroot  = location.protocol + "//" + location.host + virtualDir;

  var urlpath  = location.href.replace(urlroot, '');
  
  $('body').wrapInner('<div class="right-col"><div id="main-content">');
  $('body').append('<div class="float-clear"></div>'); // necessary otherwise sidebar would overlap the footer
  $('body').prepend('<div id="headerbar"></div><div class="left-col"><ul class="nav"><li id ="sb_content"><span>Inhalt</span></li><li id ="sb_index"><span>Index</span></li></ul><div id="sidebar"></div><div id="keywords"><input id="IndexEntry" type="text"><select id="indexcontainer" name="IndexListbox" class="docstyle" size="20"></select></div></div>');
  $('body').wrapInner('<div class="main-content"><div id="app-body">');
  $('body').prepend('<div class="header"><table class="hdr-table"><tr><td class="hdr-image"><a href="' + urlroot + '"><img src="' + urlroot + '/docs/static/ahk_logo_no_text.png" alt="AutoHotkey"></a></td><td class="hdr-search"><form id="search-form"><input id="q" size="30" type="text" placeholder="Suchbegriff eingeben ..."></form><div id="search-btn">Suchen</div></td><td class="hdr-language"><ul><li>Language<ul class="second"><li id="lng-btn-en">English</li><li id="lng-btn-de">Deutsch</li><li id="lng-btn-cn">中文</li></ul></li></ul></td></tr></table></div>');
  $('body').append('<div class="footer"><b>Copyright</b> &copy; 2003-' + new Date().getFullYear() + ' ' + location.host + ' - Lizenz: <a href="' + urlroot + '/docs/license.htm">GNU General Public License</a> | Übersetzung: Harald Bootz</div>');
  
  //
  // on events for sidebar buttons
  //

  $('#sb_content').on('click', function() { ShowTOC(); });
  $('#sb_index').on('click', function() { ShowIndex(); });

  //
  // on events for search field + button
  //

  $('.header #search-btn').on('click', function() {
    var query = $(".header #q").val();
    document.location = 'https://www.google.com/search?sitesearch=' + location.host + '&q=' + query;
  });

  $('.header #search-form').on('submit', function(event) {
      event.preventDefault();
      var query = $(".header #q").val();
      document.location = 'https://www.google.com/search?sitesearch=' + location.host + '&q=' + query;
  });

  //
  // language button
  //

  var en = 'http://ahkscript.org';
  var de = 'http://ragnar-f.github.io';
  var cn = 'http://ahkcn.sourceforge.net';

  $('#lng-btn-en').on('click', function() { document.location = en + urlpath; } );
  $('#lng-btn-de').on('click', function() { document.location = de + urlpath; } );
  $('#lng-btn-cn').on('click', function() { document.location = cn + urlpath; } );

  $('.hdr-table .hdr-language').find('li').mouseenter(function() {
    $(this).children('ul').show();
    $(this).addClass('selected');
    $(this).mouseleave(function() {
      $(this).children('ul').hide();
      $(this).removeClass('selected');
    });
  });

  //
  // set last used state of sidebar
  //

  (sessionStorage.getItem('sb_state') == 2) ? ShowIndex() : ShowTOC();

  //
  // Create toc sidebar based on HHC file (tree.jquery.js)
  //

  var source = urlroot + '/Table of Contents.hhc';

  $.get(source, function(txt)
  {
    var lines             = txt.split("\n");
    var data              = [];
    var processing        = false;
    var counter           = 0;
    var title             = '';
    var path              = '';
    var id                = 0;
    var sb_content_match  = 0;

    for (var i = 0, len = lines.length; i < len; i++)
    {
      var line = lines[i]; // required otherwise .indexOf would search through the whole array
      
      // ignore lines until first <li>

      if (line.indexOf('<LI>') >= 0)
        processing = true;
      if (!processing)
        continue;

      // analyse every toc item

      if (line.indexOf('<OBJECT type="text/sitemap">') >= 0)
      {
        id++;
        path = '';
        title = '';
      }
      if (line.indexOf('<param name="Name"') >= 0)
      {
        title = line.match(/value="(.*)"/)[1];
        title = $("<div/>").html(title).text(); // encode html entities
      }
      if (line.indexOf('<param name="Local"') >= 0)
      {
        path = line.match(/value="(.*)"/)[1];
        if ((!sb_content_match) && (urlpath.indexOf(path) >= 0)) 
          sb_content_match = id;
      }
      if (line.indexOf('</OBJECT>') >= 0)
      {
        switch(counter) {
          case 0:
            var temp0 = data;
            temp0.push({label: title, children: [], path: path, id: id});
            break;
          case 1:
            var temp1 = temp0[temp0.length - 1].children;
            temp1.push({label: title, children: [], path: path, id: id});
            break;
          case 2:
            var temp2 = temp1[temp1.length - 1].children;
            temp2.push({label: title, children: [], path: path, id: id});
            break;
          default:
            alert('sidebar item - ' + title + ': level ' + counter + ' not supported');
        }
      }
      if (line.indexOf('<UL>') >= 0)
      {
        counter++;
      }
      if (line.indexOf('</UL>') >= 0)
      {
        counter--;
      }
    }

    $(function() {

      var that = $('#sidebar');

      that.tree({
        data: data,
        useContextMenu: false,
        keyboardSupport: false
      });

      // pre-select toc sidebar item

      var sb_content_lastselected = sessionStorage.getItem('sb_content_lastselected');
      var sb_content_node_match = that.tree('getNodeById', sb_content_match);

      if (sb_content_lastselected)
      {
        var sb_content_node_last = that.tree('getNodeById', sb_content_lastselected);
        if ('/' + sb_content_node_last.path == urlpath)
          that.tree('selectNode', sb_content_node_last);
        else
          that.tree('selectNode', sb_content_node_match);
      }
      else
        that.tree('selectNode', sb_content_node_match);

      that.bind('tree.click', function(event) {
        var node = event.node;
        if (node.path)
          window.location = urlroot + "/" + node.path;
        $(this).tree('toggle', node);
        sessionStorage.setItem('sb_content_lastselected', node.id);
      });
    });
  });

  //
  // Create keyword list sidebar based on HHK file
  //

  var source = urlroot + '/Index.hhk';

  $.get(source, function(txt)
  {
    var lines           = txt.split("\n");
    var newContent      = '\n';
    var processing      = false;
    var counter         = 0;
    var sb_index_match  = 0;

    for (var i = 0, len = lines.length; i < len; i++)
    {
      var line = lines[i]; // required otherwise .indexOf would search through the whole array
      
      // ignore lines until first <li> 

      if ((!processing) && (line.indexOf('<LI>') >= 0))
        processing = true;
      if (!processing)
        continue;

      // analyse every keyword

      if (line.indexOf('<param name="Name"') >= 0)
      {
        var title = line.match(/value="(.*)"/)[1];
      }
      if (line.indexOf('<param name="Local"') >= 0)
      {
        var path = line.match(/value="(.*)"/)[1].replace('docs/', '');
      }
      if (line.indexOf('</OBJECT>') >= 0)
      {
        counter++;
        newContent += '<option value="' + path + '">' + title + '</option>\n';
        if ((!sb_index_match) && (urlpath.indexOf(path) >= 0))
        {
          sb_index_match = counter;
        }

      }
    }
    $("#indexcontainer").append(newContent);

    // pre-select keyword list sidebar item

    var sb_index_lastselected = sessionStorage.getItem('sb_index_lastselected');
    var sb_index_item_match = $('#indexcontainer :nth-child(' + sb_index_match + ')');

    if (sb_index_lastselected)
    {
      var sb_index_item_last = $('#indexcontainer :nth-child(' + sb_index_lastselected + ')');
      if ('/docs/' + sb_index_item_last.attr('value') == urlpath)
        sb_index_item_last.prop('selected', true);
      else
        sb_index_item_match.prop('selected', true);
    }
    else
      sb_index_item_match.prop('selected', true);

    // select closest listbox entry while typing

    $("#IndexEntry").on('keyup', function() {
      var oList = $('#indexcontainer')[0];
      var ListLen = oList.length;
      var iCurSel = oList.selectedIndex; 
      var text = $("#IndexEntry").val().toLowerCase();
      var TextLen = text.length;
      if (!text) return
      for (var i = 0; i < ListLen; i++) { 
        var listitem = oList.item(i).text.substr(0, TextLen).toLowerCase(); 
        if (listitem == text) { 
          if (i != iCurSel) { 
            var iPos = i + oList.size - 1; 
            if(ListLen > iPos) 
              oList.selectedIndex = iPos; 
            else 
              oList.selectedIndex = ListLen-1; 
            oList.selectedIndex = i; 
          } 
          break; 
        } 
      } 
    });

    // open document when pressing enter or select item

    $("#indexcontainer, #IndexEntry").on('keydown change', function(event) {
      if ((event.which && event.which==13) || (event.keyCode && event.keyCode==13) || (event.type == 'change')) {
        var iSelect = document.getElementById("indexcontainer").selectedIndex;
        if (iSelect >= 0) {
          var URL = document.getElementById("indexcontainer").item(iSelect).value;
          sessionStorage.setItem('sb_index_lastselected', iSelect + 1);
          if (URL.length > 0) {
            window.location = urlroot + '/docs/' + URL;
          }
        }
      }
    });
  });

  //
  // Automatically adding anchor links to the headings
  //

  $('h1, h2, h3, h4, h5, h6').each(function(index) {
    if(!$(this).attr('id')) // if id anchor not exist, create one
    {
      
      var str = $(this).text().replace(/\s/g, '_'); // replace spaces with _
      var str = str.replace(/[():.,#\[\]\/{}&="|?!]/g, ''); // remove special chars
      if($('#' + str).length) // if new id anchor exist already, set it to a unique one
        $(this).attr('id', str + '_' + index);
      else
        $(this).attr('id', str);
    }
    $(this).wrap('<a class="anchorlink" href="#' + $(this).attr('id') + '"></a>');
  });
});

function ShowTOC()
{
  sessionStorage.setItem('sb_state', 1);
  $('#sb_content').attr('class', 'selected');
  $('#sb_index').removeAttr('class');
  $('#keywords').hide();
  $('#sidebar').show();
}

function ShowIndex()
{
  sessionStorage.setItem('sb_state', 2);
  $('#sb_index').attr('class', 'selected');
  $('#sb_content').removeAttr('class');
  $('#sidebar').hide();
  $('#keywords').show();
}