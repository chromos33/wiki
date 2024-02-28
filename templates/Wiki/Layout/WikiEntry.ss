<% require javascript('public/resources/wiki/client/js/bootstrap-native-v4.min') %>
<% require css('public/resources/wiki/client/css/wiki.css') %>
<% include Wiki/WikiAddEntryModal %>
<% include Wiki/WikiSearch %>
<div class="container mt-4 mb-4">
    <div class="row">
        <div class="col-4 typography">
            <% loop $Parent.Children %>
                <% if $ClassName == "Wiki\WikiEntry" %>
                <div class="relative wikipost">
                    <div class="showAddOnHover">
                        <span class="<% if Children %>foldericon<% else %>wikientryicon<% end_if %> d-inline-block vertical-top mr-1">
                            <% if Children %>
                            <i class="fas fa-folder-plus font_green"></i>
                            <i class="fas fa-folder-minus font-green"></i>
                            <% else %>
                            <i class="far fa-file-alt"></i>
                            <% end_if %>
                        </span>
                        <span class="d-inline-block h3 wiki_title vertical-top">
                            <a class="mb-0" href=$Link>$Title</a>
                        </span>
                        <button type="button" data-toggle="modal" data-target="#AddWikiEntry" data-Entry="$ID" data-Wiki="$WikiID" class="AddWikiPageModal">
                            <span>+</span>
                        </button>
                    </div>
                    <% if Children %>
                    <div class="foldercontent">
                        <div class="heightgiver">
                            <% loop Children %>
                                <div class="relative wikipost showAddOnHover">
                                    <span class="<% if Children %>foldericon<% else %>wikientryicon<% end_if %> d-inline-block vertical-top mr-1">
                                        <% if Children %>
                                        <i class="fas fa-folder-plus font_green"></i>
                                        <i class="fas fa-folder-minus font-green"></i>
                                        <% else %>
                                        <i class="far fa-file-alt"></i>
                                        <% end_if %>
                                    </span>
                                    <span class="d-inline-block h3 wiki_title vertical-top">
                                        <a class="mb-0" href=$Link>$Title</a>
                                    </span>
                                    <button type="button" data-toggle="modal" data-target="#AddWikiEntry" data-Entry="$ID" data-Wiki="$WikiID" class="AddWikiPageModal">
                                        <span>+</span>
                                    </button>
                                </div>
                            <% end_loop %>
                        </div>
                    </div>
                    <% end_if %>
                </div>
                <% end_if %>
            <% end_loop %>
        </div>
        <div class="col-8">
            <% if IsEditMode %>
            <div class="mb-4 typography">
            $EntryEditForm
            </div>
            <% else %>
            <div class="typography mb-4" id="WikiReactContainer">
                <h1><i class="fal fa-file-alt"></i> $Title</h1>
                <div class="border-bottom-light-1 pb-3 mb-4">
                    <span>
                        <i class="far fa-calendar" style="margin-top:-4px;"></i> <span class="vertical-top">$Created.Format('dd.mm.Y')</span>
                    </span>
                    <a href="{$Link}?Mode=Edit" style="margin-top:-8px !important;" class="btn btn-green right m-0"><i class="far fa-pencil"></i> <%t Wiki.EditPage "bearbeiten" %></a>
                </div>
                $Content
            </div>
            <% end_if %>
            <% if Files %>
            <div class="row">
                <div class="col-12 typography">
                    <span class="h1 border-bottom-light-1"><i class="far fa-paperclip vertical-top d-inline-block"></i> <span class="d-inline-block"><%t Wiki.AddedFiles "Angehängte Dateien" %></span></span>
                </div>
            <% loop Files %>
            <div class="col-12 pb-4 typography border-bottom-light-1">
                <div class="row">
                    <div class="col-8">
                        <span class="h3">$Title</span>
                        <p class="mb-2">
                            <%t Downloads.TYPE "Format" %>: $FileType   
                            <%t Downloads.FILESIZE %>: $Size
                        </p>
                    </div>
                    <div class="col-4">
                        <a class="right" href="$File.Link"><i class="fal fa-arrow-circle-down"></i> <%t Downloads.DOWNLOAD %></a>
                        <% if Up.IsEditMode %>
                            <br/><a href="wiki/deleteFile/{$ID}/{$Up.ID}" class="right btn btn-red"><%t Wiki.DELETE "Löschen" %></a>
                        <% end_if %>
                    </div>
                </div>
                
            </div>
            <% end_loop %>
            </div>
            <% end_if %>
        </div>
    </div>
</div>
<script>
    document.querySelectorAll(".AddWikiPageModal").forEach((e) => {
        e.addEventListener("click",(e) => {
            let dataEntry = getAttribute(e.target,"data-Entry");
            let dataWiki = getAttribute(e.target,"data-Wiki");
            document.querySelector("#ModelDataNode").setAttribute("data-wiki",dataWiki);
            document.querySelector("#ModelDataNode").setAttribute("data-entry",dataEntry);
        });
    });
    function getAttribute(node,attribute)
    {
        if(node.classList.contains(".AddWikiPageModal"))
        {
            return node.getAttribute(attribute)
        }
        return node.closest(".AddWikiPageModal").getAttribute(attribute)
    }
    document.querySelectorAll(".foldericon").forEach((e) => {
        e.addEventListener("click",(e) => {
           
            let folderContent = getFolderContentNode(e.target)
            if(folderContent != undefined)
            {
                
                if(getCurrentHeight(folderContent) == 0)
                {
                    getFolderIconNode(e.target).classList.add("open");
                    let height = getSpannedHeight(folderContent);
                    folderContent.style.height = height+"px";
                    folderContent.style.marginBottom = 20+"px";
                }
                else
                {
                    getFolderIconNode(e.target).classList.remove("open");
                    folderContent.style.height = 0;
                    folderContent.style.marginBottom = 0;
                }
            }
            
        });
    });
    function getFolderIconNode(node)
    {
        if(node.classList.contains("foldericon"))
        {
            return node;
        }
        return node.closest(".foldericon");
    }
    function getCurrentHeight(node)
    {
        return node.clientHeight;
    }
    function getSpannedHeight(node)
    {
        return node.querySelector(".heightgiver").clientHeight;
    }
    function getFolderContentNode(node)
    {
        return node.closest(".wikipost").querySelector(".foldercontent");
    }
</script>
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
        return document.querySelector("#ModelDataNode").getAttribute("data-entry");
    }
    function getWikiId()
    {
        return document.querySelector("#ModelDataNode").getAttribute("data-wiki");
    }
</script>
<% if IsEditMode %>
<script src="public/resources/wiki/client/js/ckeditor.js"></script>
<script>
    ClassicEditor.create(document.querySelector("#WikiReactContainer"),{
        autosave: {
            save(editor){                
                const xhr = this.xhr = new XMLHttpRequest();

                xhr.open("POST","wiki/saveContent",true);
                xhr.responseType = "json";
                const data = new FormData();
                data.append( 'Content', editor.getData());
                data.append('ID',{$ID});

                // Important note: This is the right place to implement security mechanisms
                // like authentication and CSRF protection. For instance, you can use
                // XMLHttpRequest.setRequestHeader() to set the request headers containing
                // the CSRF token generated earlier by your application.

                // Send the request.
                this.xhr.send( data );
            }
        }
    })
        .then(editor => {
            editor.plugins.get("FileRepository").createUploadAdapter = (loader) => {
                return new ImageUploadAdapter(loader);
            }
        }).catch(error => {
            //console.error(error);
        });
        class ImageUploadAdapter{
            constructor(loader){
                this.loader = loader;
            }
            upload(){
                return this.loader.file.then(
                    file => new Promise((resolve,reject) => {
                        this._initRequest();
                        this._initListeners(resolve,reject,file);
                        this._sendRequest(file);
                    })
                );
            }
            _initRequest(){
                const xhr = this.xhr = new XMLHttpRequest();

                xhr.open("POST","wiki/uploadImage",true);
                xhr.responseType = "json";
            }
            _initListeners(resolve,reject,file){
                const xhr = this.xhr;
                const loader = this.loader;
                const genericErrorText = `Couldn't upload file: ${ file.name }.`;

                xhr.addEventListener( 'error', () => reject( genericErrorText ) );
                xhr.addEventListener( 'abort', () => reject() );
                xhr.addEventListener( 'load', () => {
                    const response = xhr.response;

                    // This example assumes the XHR server's "response" object will come with
                    // an "error" which has its own "message" that can be passed to reject()
                    // in the upload promise.
                    //
                    // Your integration may handle upload errors in a different way so make sure
                    // it is done properly. The reject() function must be called when the upload fails.
                    if ( !response || response.error ) {
                        return reject( response && response.error ? response.error.message : genericErrorText );
                    }

                    // If the upload is successful, resolve the upload promise with an object containing
                    // at least the "default" URL, pointing to the image on the server.
                    // This URL will be used to display the image in the content. Learn more in the
                    // UploadAdapter#upload documentation.
                    resolve( {
                        default: response.url
                    } );
                } );

                // Upload progress when it is supported. The file loader has the #uploadTotal and #uploaded
                // properties which are used e.g. to display the upload progress bar in the editor
                // user interface.
                if ( xhr.upload ) {
                    xhr.upload.addEventListener( 'progress', evt => {
                        if ( evt.lengthComputable ) {
                            loader.uploadTotal = evt.total;
                            loader.uploaded = evt.loaded;
                        }
                    } );
                }
            }
            _sendRequest( file ) {
                // Prepare the form data.
                const data = new FormData();

                data.append( 'upload', file );

                // Important note: This is the right place to implement security mechanisms
                // like authentication and CSRF protection. For instance, you can use
                // XMLHttpRequest.setRequestHeader() to set the request headers containing
                // the CSRF token generated earlier by your application.

                // Send the request.
                this.xhr.send( data );
            }
            abort()
            {

            }
        }
</script>
<% end_if %>
<script>
function getId(url) {
    if(url.indexOf("youtube.com/watch?v=") !== -1)
    {
        let split = url.split("youtube.com/watch?v=");
        return split[1];;
    };
    return undefined;
}

    document.querySelectorAll("oembed").forEach((e) => {
        let url = e.getAttribute("url");
        var videoId = getId(url);
        if(videoId != undefined)
        {
            e.parentNode.innerHTML = '<iframe width="560" height="315" src="//www.youtube.com/embed/' 
            + videoId + '" frameborder="0" allowfullscreen></iframe>';
        }
    });
</script>