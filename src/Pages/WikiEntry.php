<?php
namespace Wiki;
use Page;
use SilverStripe\Dev\Debug;
use SilverStripe\Assets\File;
use SilverStripe\Security\Permission;

class WikiEntry extends Page
{
    private static $tablename = "WikiEntry";
    private static $db = [
        "EditorID"  =>  "Int",
        "LockedTill"    =>  "Int"
    ];
    private static $many_many = [
        "Files" =>  File::class
    ];
    //LockTime in Seconds
    private const LockTime = 1*60*60;

    public function EditOpen($RequestEditorID = 0)
    {
        if($RequestEditorID == $this->EditorID)
        {
            return true;
        }
        return $this->LockedTill < strtotime(date("d.m.Y H:i:s"));
    }
    public function LockEdit($RequestEditorID = 0)
    {
        $this->EditorID = $RequestEditorID;
        $this->LockedTill = strtotime(date("d.m.Y H:i:s")) + Self::LockTime;
        $this->write();
        $this->publishSingle();
    }
    public function UnlockEdit()
    {
        $this->LockedTill = 0;
        $this->EditorID = 0;
        $this->write();
        $this->publishSingle();
    }
    public function canEdit($member = null)
    {
        return Permission::check('CANEDITWIKIPAGES');
    }
    public function canView($member = null)
    {
        return Permission::check('CANVIEWWIKIPAGES');
    }

    public function LimitedChildren($limit)
    {
        return $this->Children()->limit($limit);
    }
    public function WikiID()
    {
        $page = $this->Parent();
        while($page->ClassName != Wiki::class && $page->Parent() != null)
        {
            $page = $page->Parent();
        }
        if($page->ClassName == Wiki::class)
        {
            return $page->ID;
        }
        return 0;
    }
}