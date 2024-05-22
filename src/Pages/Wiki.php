<?php

namespace Wiki;
use Page;
use SilverStripe\Security\Permission;

class Wiki extends Page
{
    private static $tablename = "Wiki";
    private static $allowed_children = [
        WikiEntry::class
    ];
    public function RandomWikiEntries($limit = 4)
    {
        return WikiEntry::get()->sort("RAND() ASC")->limit($limit);
    }
    public function canEdit($member = null)
    {
        $result = parent::canEdit($member);
        if($result == true)
        {
           return Permission::check('CANEDITWIKIPAGES'); 
        }
        return false;
    }
    public function canView($member = null)
    {
        $result = parent::canView($member);
        if($result == true)
        {
           return Permission::check('CANVIEWWIKIPAGES');
        }
        return false;
    }
}   
