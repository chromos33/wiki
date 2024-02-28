<?php
namespace Wiki;
use Wiki\Wiki;
use PageController;
use Wiki\WikiEntry;
use SilverStripe\Dev\Debug;
use SilverStripe\Forms\Form;
use SilverStripe\Assets\File;
use SilverStripe\Core\Convert;
use SilverStripe\Assets\Folder;
use SilverStripe\Forms\FieldList;
use SilverStripe\Forms\FormAction;
use SilverStripe\Security\Security;
use SilverStripe\View\Requirements;
use SilverStripe\CMS\Model\SiteTree;
use SilverStripe\Control\Controller;
use SilverStripe\Security\Permission;
use SilverStripe\Forms\RequiredFields;
use SilverStripe\Security\PermissionProvider;
use SilverStripe\Forms\HTMLEditor\HTMLEditorField;

class WikiController extends PageController implements PermissionProvider
{
    public function providePermissions()
    {
        return [
            'CANEDITWIKIPAGES' => 'Kann Wiki Seiten bearbeiten',
            'CANVIEWWIKIPAGES' => 'Kann Wiki Seiten betrachten'
        ];
    }
    private static $allowed_actions = [
        "AddWikiEntry" =>   true,
        "IsEditMode"    =>  true,
        'FrontEndEditForm'      =>  true,
        'uploadImage'   => true,
        'saveContent'   =>  true,
        'EntryEditForm'  =>  true,
        'deleteFile'    =>  true,
        'search'    =>  true
    ];

    public function search()
    {
        $searchterm = Convert::raw2sql($_GET["searchTerm"]);
        if($searchterm == "")
        {
            return "<span>"._t("Wiki.NORESULTS", "Suche ergab keine Ergebnisse")."</span>";
        }
        $results = WikiEntry::get()->filter([
            "Title:PartialMatch" => $searchterm
        ]);
        if(count($results) > 0)
        {
            return $this->customise([
                "Results" => $results
            ])->renderWith("Wiki/SearchResults");
        }
        return "<span>"._t("Wiki.NORESULTS", "Suche ergab keine Ergebnisse")."</span>";
    }

    public function deleteFile()
    {
        $FileID = Convert::raw2sql($this->getRequest()->params()["ID"]);
        $WikiEntryID = Convert::raw2sql($this->getRequest()->params()["OtherID"]);

        $WikiEntry = WikiEntry::get()->byID($WikiEntryID);
        $WikiEntry->Files()->removeByID($FileID);
        $WikiEntry->write();
        $WikiEntry->publishSingle();
    }

    public function SaveContent()
    {
        if(array_key_exists("Content",$_POST) && array_key_exists("ID",$_POST))
        {
            $Content = Convert::raw2sql($_POST["Content"]);
            $Content = str_replace(["\&quot;"],"",$Content);
            $Content = str_replace(['\\"'],'"',$Content);
            $WikiPage = WikiEntry::get()->byID(Convert::raw2sql($_POST["ID"]));
            if($WikiPage->Content != $Content)
            {
                $WikiPage->Content = $Content;
                $WikiPage->write();
            }
        }
        
    }

    public function uploadImage()
    {
        $filecontents = file_get_contents($_POST["upload"]["tmp_name"]);
        if($filecontents)
        {
            $filename = Convert::raw2sql($_POST["upload"]["name"]);
            $file = File::create();
            Folder::find_or_make("Wiki");
            $file->setFromString($filecontents,"Wiki/".$filename);
            $file->write();
            $file->publishFile();
            $file->publishSingle();
            return json_encode([
                "url" => $file->Link()
            ]);
        }
        
    }
    public function canEdit($member = null)
    {
        return Permission::check('CANEDITWIKIPAGES');
    }
    public function AddWikiEntry()
    {
        if($this->canEdit(null))
        {
            $json = str_replace(["\\r", "\\n", "\\"], "", Convert::raw2sql($this->getRequest()->getBody()));
            $data = json_decode($json);
            $title = $this->getWikiPageTitle($data);
            $mode = $this->getAddMode($data);
            if($mode)
            {
                $wikientry = $this->createWikiEntry($title);
                $wikientry->ParentID = $this->getWikiEntryParentID($mode,$data);
                $wikientry->write();
                return $wikientry->Link()."?Mode=Edit";
            }
        }
        return "";

       
    }
    private function getWikiEntryParentID($mode,$data)
    {
        switch($mode)
        {
            case "ToRoot":
                return $data->wiki;
            case "AsChild":
                return $data->addTarget;
            case "AsSibling":
                return SiteTree::get()->byID($data->addTarget)->ParentID;
        }
    }
    private function createWikiEntry($title)
    {
        $page = new WikiEntry();
        $page->Title = $title;
        return $page;
    }
    private function getWikiPageTitle($data)
    {
        $title ="Neue Wiki Seite";
        if($data->title != null && $data->title != "")
        {
            return $data->title;
        }
        return $title;
    }
    private function getAddMode($data)
    {
        if($data->addTarget != null)
        {
            $AddTargetID = $data->addTarget;
            $AddTargetPage = SiteTree::get()->byID($AddTargetID);
            switch($AddTargetPage->ClassName)
            {
                case Wiki::class:
                    return "ToRoot";
                default: 
                    if($data->saveType != null && $data->saveType != "")
                    {
                        return $data->saveType;
                    }
                    return "AsChild";
            }
        }
        return false;
    }
}