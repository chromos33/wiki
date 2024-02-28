<% require javascript('public/resources/wiki/client/js/bootstrap-native-v4.min') %>
<% require css('public/resources/wiki/client/css/wiki.css') %>
<% include Wiki/WikiAddEntryModal %>
<% include Wiki/WikiSearch %>
<% if RandomWikiEntries %>
<div class="container">
    <div class="row">
        <% loop RandomWikiEntries %>
            <div class="col-12 col-sm-6 mt-md-5 mt-3 mb-md-5 mb-3 col-md-3 typography">
                <div style="height:100%;" class="border p-4 text-center">
                    <span class="h2">$Title</span>
                    <p>$Content.LimitWordCount(20)</p>
                    <a href="$Link"><%t Wiki.ToEntry "Zum Eintrag" %></a>
                </div>
            </div>
        <% end_loop %>
    </div>
</div>
<% end_if %>
<div class="border-bottom-light-1">
    <div class="container">
        <div class="row typography mt-5 mb-3">
            <div class="col-12">
                <span class="h1">$Title</span>
                $Content
            </div>
        </div>
    </div>
</div>
<div class="border-bottom-light-1 mt-5 mb-5 pb-5">
    <div class="container">
        <div class="row typography">
            <div class="col-12 text-center">
                    <button type="button" class="btn btn-grey js_AddWikiEntryToRoot" data-toggle="modal" data-target="#AddWikiEntry"><i class="far fa-plus"></i> <%t Wiki.ADDCATEGORY "Kategorie hinzufügen" %></button>
            </div>
        </div>
    </div>
</div>
<div class="container">
    <div class="row typography">
        <% loop Children %>
            <div class="col-12 col-sm-6 col-md-4 mb-5">
                <span class="d-inline-block wiki_icon bg-green vertical-top font_white"><% if Children %>$Children.Count<% else %>1<% end_if %></span>
                <span class="d-inline-block h3 wiki_title"><a class="mb-0" href="$Link">$Title</a></span>
                <% if Children %>
                    <div class="row mb-3">
                        <% loop $LimitedChildren(5) %>
                        <div class="col-12 mb-2">
                            <a class="mb-0" href="$Link">
                                <span class="d-inline-block wiki_icon"><i class="far fa-file-alt"></i></span>
                                <span class="d-inline-block wiki_title">$Title</span>
                            </a>
                        </div>
                        <% end_loop %>
                    </div>
                <% end_if %>
                <% if Children %>
                <a class="d-block" href="$Link"><i class="fal fa-long-arrow-right"></i> <%t Wiki.MORE "Alle Themen anzeigen" %></a>
                <% else %>
                <a class="d-block" href="$Link"><i class="fal fa-long-arrow-right"></i> <%t Wiki.ToEntry "Zum Eintrag" %></a>
                <% end_if %>
            </div>
        <% end_loop %>
    </div>
</div>

<script>
    document.querySelector("#AddWikiEntry .btn-primary").addEventListener("click",function(){
        var POST = {
            saveType: "ToRoot",
            title: getTitle(),
            addTarget: $ID,
            wiki: $ID
        }
        var request = new XMLHttpRequest();
        request.open("POST","/wiki/AddWikiEntry");
        request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        request.onload = function()
        {
            var link = request.response;
            window.location.href = link;
        }
        request.send(JSON.stringify(POST));
    });
    function getSaveType()
    {
        return document.querySelector("#AddWikiEntry input[name='SaveType']:checked").value;
    }
    function getTitle()
    {
        return document.querySelector("#AddWikiEntry input[name='title']").value;
    }
</script>