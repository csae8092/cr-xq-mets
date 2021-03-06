xquery version "3.0";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://exist-db.org/xquery/apps/config-params" at "core/config.xql";
import module namespace configm="http://exist-db.org/xquery/apps/config" at "core/config.xqm";
import module namespace project="http://aac.ac.at/content_repository/project" at "core/project.xqm";

(: The following external variables are set by the repo:deploy function :)

(: file path pointing to the exist installation directory :)
declare variable $home external;
(: path to the directory containing the unpacked .xar package :)
declare variable $dir external;
(: the target collection into which the app is deployed :)
declare variable $target external;

declare function local:mkcol-recursive($collection, $components) {
    if (exists($components)) then
        let $newColl := concat($collection, "/", $components[1])
        return (
            xdb:create-collection($collection, $components[1]),
            local:mkcol-recursive($newColl, subsequence($components, 2))
        )
    else
        ()
};

(: Helper function to recursively create a collection hierarchy. :)
declare function local:mkcol($collection, $path) {
    local:mkcol-recursive($collection, tokenize($path, "/"))
};

declare variable $local:cr-writer:=doc($target||"/modules/access-control/writer.xml")/write;

declare variable $local:projects-xconf := doc($target||"/_cr-projects_xconf.xml");  
    
util:log("INFO", "$target: "|| $target),
(: setup projects-dir :)
local:mkcol("", $config:projects-dir),
local:mkcol("", $config:data-dir),
(: store the collection configuration :)
local:mkcol("/db/system/config", $target),
xdb:store-files-from-pattern(concat("/system/config", $target), $dir, "*.xconf"),
(: store the cr-projects collection configuration :)
local:mkcol("/db/system/config", $config:projects-dir),
xdb:store("/db/system/config/"||$config:projects-dir,'collection.xconf',$local:projects-xconf),
(: preparea a collection for the cr-data collection configuration :)
local:mkcol("/db/system/config", $config:data-dir),
xdb:reindex($config:projects-dir),
xdb:reindex($target),

(: we need two system users for the data maangement :)
(: TODO merge these into one? :)
util:log("INFO", "** setting up writer account **"),
if (not(sm:user-exists(xs:string($local:cr-writer/write-user)))) then sm:create-account(xs:string($local:cr-writer/write-user),xs:string($local:cr-writer/write-user-cred),()) else sm:passwd(xs:string($local:cr-writer/write-user),xs:string($local:cr-writer/write-user-cred)),
util:log("INFO", "** setting up cr-xq system account **"),
if (not(sm:user-exists($config:system-account-user))) then sm:create-account($config:system-account-user,$config:system-account-pwd,$config:system-account-user,()) else sm:passwd($config:system-account-user,$config:system-account-pwd),
if (not(sm:group-exists("cr-admin"))) then sm:create-group("cr-admin",$config:system-account-user,"admin") else (),
util:log("INFO", "** chown "||$config:projects-dir||" "||$config:system-account-user||":cr-admin"),
sm:chown(xs:anyURI($config:projects-dir),$config:system-account-user),
sm:chgrp(xs:anyURI($config:data-dir),'cr-admin'),
util:log("INFO", "** chown "||$config:data-dir||" "||$config:system-account-user||":cr-admin"),
sm:chown(xs:anyURI($config:projects-dir),$config:system-account-user),
sm:chgrp(xs:anyURI($config:data-dir),'cr-admin'),
util:log("INFO", "** setting up default project 'defaultProject' **"),
project:new("defaultProject")
