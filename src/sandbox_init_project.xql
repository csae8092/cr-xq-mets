xquery version "3.0";

import module namespace config="http://exist-db.org/xquery/apps/config" at "core/config.xqm"; 
import module namespace project = "http://aac.ac.at/content_repository/project" at "core/project.xqm";


let $project-pid := 'Eckhel-Online'
let $new-project := project:new($project-pid)
return if (exists($new-project)) then  ("Created project: "||$project-pid||" in "||config:path('projects'), $new-project)
          else if (exists(project:get($project-pid))) then "Project "||$project-pid||" already exists."
          else "Project "||$project-pid||" could not be instantiated."
