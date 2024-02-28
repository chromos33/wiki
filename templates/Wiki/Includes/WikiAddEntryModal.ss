<div class="modal fade" id="AddWikiEntry" tabindex="-1" role="dialog" aria-labelledby="AddWikiEntry" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel"><%t Wiki.ADDPAGE "Wiki Seite hinzufügen" %></h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body typography">
            <input type="text" name="title" placeholder="<%t Wiki.TITLE 'Titel' %>"/>
            <% if $ClassName = "Wiki\WikiEntry" %>
            <div class="d-flex flexradio mt-3">
                <input type="radio" id="AsChild" name="SaveType" checked="true" value="AsChild">
                <label for="AsChild"><%t Wiki.ASCHILD "Unterhalb der ausgewählten Seite" %></label>
            </div>
            <div class="d-flex flexradio">
                <input type="radio" id="AsSibling" name="SaveType" value="AsSibling">
                <label for="AsSibling"><%t Wiki.ASSIBLING "Neben der ausgewählten Seite" %></label>
            </div>
            <% end_if %>
            <span Id="ModelDataNode" data-wiki="" data-entry=""></span>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal"><%t Wiki.CLOSE "Schliesen" %></button>
            <button type="button" class="btn btn-primary"><%t Wiki.CREATEPAGE "Wiki Seite erstellen" %></button>
        </div>
        </div>
    </div>
</div>