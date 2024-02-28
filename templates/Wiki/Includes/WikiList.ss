



<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#AddWikiEntry"><%t Wiki.ADDPAGE "Wiki Seite hinzufügen" %></button>


<script>
    document.querySelector("#AddWikiEntry .btn-primary").addEventListener("click",function(){
        var POST = {
            saveType: getSaveType(),
            title: getTitle(),
            addTarget: getWikiEntryId(),
            wiki: getWikiId()
        }
        var request = new XMLHttpRequest();
        request.open("POST","/wiki/AddWikiEntry");
        request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        request.onload = function()
        {
            var link = request.response;
            //alert(link);
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
    function getWikiEntryId()
    {

    }
    function getWikiId()
    {

    }
</script>