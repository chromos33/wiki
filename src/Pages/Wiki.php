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
        return Permission::check('CANEDITWIKIPAGES');
    }
    public function canView($member = null)
    {
        return Permission::check('CANVIEWWIKIPAGES');
    }
}   