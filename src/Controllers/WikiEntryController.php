<?php

namespace Wiki;

use PageController;
use SilverStripe\Dev\Debug;
use SilverStripe\Forms\Form;
use SilverStripe\Assets\File;
use SilverStripe\Core\Convert;
use SilverStripe\Forms\FieldList;
use SilverStripe\Forms\TextField;
use SilverStripe\Forms\FormAction;
use SilverStripe\Security\Security;
use SilverStripe\View\Requirements;
use SilverStripe\Forms\RequiredFields;
use UncleCheese\Dropzone\FileAttachmentField;
use SilverStripe\Forms\HTMLEditor\HTMLEditorField;

class WikiEntryController extends PageController
{
    private static $allowed_actions = [
        "EntryEditForm"  =>  true
    ];
    protected function init()
    {
        parent::init();

        Requirements::javascript('silverstripe/admin:thirdparty/tinymce/tinymce.min.js');
        Requirements::css('silverstripe/admin:client/dist/styles/editor.css');
    }
    private function checkLoginAndRedirect()
    {
        if (Security::getCurrentUser() == null || Security::getCurrentUser() != null && (Security::getCurrentUser()->ID == 0 || Security::getCurrentUser()->ID == null)) {
            $controller = Controller::curr();
            return $controller->redirect(Controller::join_links(Security::config()->uninherited('login_url'), "?BackURL=" . urlencode($_SERVER['REQUEST_URI']) . "&askregister=1"));
        }
    }
    
    public function index()
    {
        $RequestEditorID = Security::getCurrentUser()->ID;
        if(array_key_exists("Mode",$_GET) && !$this->EditOpen($RequestEditorID))
        {
            return $this->redirect($this->Link());
        }
        else
        {
            $this->LockEdit($RequestEditorID);
        }
        
        return $this->customise(['canEdit' => $this->data()->canEdit()])->renderWith(["Wiki/WikiEntry","Page"]);
    }


    public function EntryEditForm()
    {
        $fields = new FieldList(
            TextField::create('Title', _t("Wiki.Title", 'Titel'),$this->Title),
            FileAttachmentField::create('ExtraFiles', _t("Wiki.UPLOADFILES", 'Dateien hochladen'))
            ->setMultiple(true)
        );
        $actions = new FieldList(
            FormAction::create('handleEntryEditForm')->setTitle(_t("Wiki.SAVE", 'Speichern'))
        );
        $required = new RequiredFields();
        $form = new Form($this, 'EntryEditForm', $fields, $actions, $required);
        $form->setTemplate("Wiki/EntryEditForm");
        $form->customise(["Page" => $this]);
        return $form;
    }

    public function handleEntryEditForm($data,Form $form)
    {
        $entry = WikiEntry::get()->byID($this->ID);
        $entry->Title = Convert::raw2sql($data["Title"]);
        $entry->MetaDescription = Convert::raw2sql($data["Title"]);
        $entry->write();
        $entry->publishSingle();
        foreach($data["ExtraFiles"] as $FileID)
        {
            $ID = Convert::raw2sql($FileID);
            if(count($entry->Files()->filter("ID",$ID)) == 0)
            {
                //Add
                $file = File::get()->byID($ID);
                if($file != null)
                {
                    $entry->Files()->add($file);
                }
            }
        }
        $entry->write();
        $entry->publishSingle();
        $entry->UnlockEdit();
        return $this->redirect($entry->Link());
    }
    
    public function IsEditMode()
    {
        $vars = $this->getRequest()->getVars();
        if(array_key_exists("Mode",$vars))
        {
            return true;
        }
        return false;
    }
}   
