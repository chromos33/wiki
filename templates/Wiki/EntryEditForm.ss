<div class="js_formcontainer">
<% if $IncludeFormTag %>
    <form $AttributesHTML>
<% end_if %>
<% if $Message %>
        <p id="{$FormName}_error" class="message $MessageType">$Message</p>
<% else %>
        <p id="{$FormName}_error" class="message $MessageType" style="display: none"></p>
<% end_if %>

   <fieldset>
        <div class="row pb-5">
            <div class="d-none">$Fields.fieldByName(SecurityID).FieldHolder</div>
            <div class="col-12">
                $Fields.fieldByName(Title).FieldHolder
            </div>
            <div class="col-12 mb-3">
                <label class="form__field-label"><%t Wiki.CONTENT "Inhalt" %></label>
                <div id="WikiReactContainer"> 
                    $Page.Content
                </div>
            </div>
            <div class="col-12">$Fields.fieldByName(ExtraFiles).FieldHolder</div>
            
        </div>
    </fieldset>
<% if $Actions %>
    <div class="btn-toolbar">
        <% loop $Actions %>
            $Field
        <% end_loop %>
    </div>
<% end_if %>
<% if $IncludeFormTag %>
    </form>
<% end_if %>
</div>
<script>
    document.querySelector(".js_formcontainer form").addEventListener("submit",(e) => {
        e.target.querySelectorAll(".input-attached-file").forEach((item) => {
            item.value = item.value.trim();
        });
    });
</script>