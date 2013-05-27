function SetLink(url)
{
    if (typeof url === "object")
        url = url.getAttribute("href");

    var ss = '<section>'
            +'<a href="http://l.autohotkey.net/docs/'+url+'" style="float: right;">Originalseite</a>'
            +'Permalink: <a href="http://ragnar-f.github.io/docs/'+url+'">http://ragnar-f.github.io/docs/'+url+'</a>'
            +'</section>'
    top.right.document.getElementById("helpbar").innerHTML = ss;
}