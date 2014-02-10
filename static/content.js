// Automatically adding anchor links to the headings
// Inspired by http://cweiske.de/tagebuch/html-heading-links.htm#php
// Requires jquery

$(document).ready(function() {
    // $('h1').each(function() {
    //     $(this).wrap('<a class="anchorlink" href="' + window.location.pathname + '">');
    // });
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
});