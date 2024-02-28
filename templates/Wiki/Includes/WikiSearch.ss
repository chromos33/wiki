<% include Breadcrumbs %>
<div class="bg_darkerblue">
    <div class="container">
          <div class="row py-5">
                <div class="col-12 typography ">
                    <div class="row">
                        <div class="col-9 col-sm-11 col-md-11 relative">
                            <input class="searchbox" placeholder="<%t Wiki.SEARCH 'Suchen sie nach einem Thema' %>" type="text"></input>
                            <div class="searchresult">
                                
                            </div>
                        </div>
                        <div class="col-3 col-sm-1 col-md-1">
                            <span class="wikiSearchButton btn btn-green"><i class="fas fa-search"></i></span>
                        </div>
                    </div>
                </div>
          </div>
    </div>
</div>
<style>
    .searchresult a,
    .searchresult > span
    {
        display:block;
        padding:15px 20px;
        background:white;
        color:#003087 !important;
        width:100%;
        background:#e6ebf1;
    }
    .searchresult a:hover{
        text-decoration: none !important;
    }
    .searchbox
    {
        padding:9px .75rem;
    }
    .searchresult
    {
        position:absolute;
        top:100%;
        left:15px;
        width:calc(100% - 30px);
        z-index: 500;
    }
</style>
<script>
    document.querySelector(".searchbox").addEventListener("change",handleSearchInput,false);
    document.querySelector(".searchbox").addEventListener("input",handleSearchInput,false);
    document.querySelector(".wikiSearchButton").addEventListener("click",handleSearch,false);

    document.querySelector(".searchbox").addEventListener("focusout",(e) => {
        document.querySelector(".searchresult").style.display = "none";
    });
    document.querySelector(".searchbox").addEventListener("focusin",(e) => {
        document.querySelector(".searchresult").style.display = "block";
    });

    function handleSearchInput(e)
    {
        let value = e.target.value;
        if(value.length > 4)
        {
            Search(value);
        }
    }
    function handleSearch(e)
    {
        Search(document.querySelector(".searchbox").value);
    }
    function Search(value)
    {
        var request = new XMLHttpRequest();
        request.open("GET","/wiki/search?searchTerm="+value);
        request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        document.querySelector(".searchresult").style.display = "block";
        request.onload = function()
        {
            document.querySelector(".searchresult").innerHTML = request.response;
        }
        request.send();
    }
</script>