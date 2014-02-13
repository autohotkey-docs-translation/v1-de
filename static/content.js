function IsInFrame()
{
  if ((top.right == null) || (top.right == undefined) || (top.right.location == null) || (top.right.location == undefined) || (typeof(top.right.location.href) != "string") || (top.right.location.href == ""))
    return false;  //no nav found
  else
    return true;  //nav found
}

$(document).ready(function() {

    // Automatically adding anchor links to the headings
    // Inspired by http://cweiske.de/tagebuch/html-heading-links.htm#php
    // Requires jquery

    $('h1, h2, h3, h4, h5, h6').each(function(index) {
        if(!$(this).attr('id')) // if id anchor not exist, create one
        {
            var str = $(this).text().replace(/\s/g, '_'); // replace spaces with _
            var str = str.replace(/(\(|\)|:|\.|,|#|\[|\]|\/|\{|\}|&|=)/g, ''); // remove special chars
            if($('#' + str).length) // if new id anchor exist already, set it to a unique one
                $(this).attr('id', str + '_' + index);
            else
                $(this).attr('id', str);
        }
        $(this).wrap('<a class="anchorlink" href="#' + $(this).attr('id') + '">');
    });

    // Ensures correct address display of links when site is framed

    var cache = false;
    $(top.right).on('load', function() {
        if (jQuery.type(top.history.state) !== 'null')
            cache = top.history.state.url;
        var url = window.location.href;
        // console.log(cache + '\n' + url);
        if (cache != url) {
            top.history.replaceState({url: url}, null, url);
        }
    });
});

