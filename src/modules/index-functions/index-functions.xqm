xquery version '3.0';
module namespace ixfn = "http://aac.ac.at/content-repository/projects-index-functions/"; 

import module namespace ixfn-Gernot='http://aac.ac.at/content-repository/projects-index-functions/Gernot' at '/db/cr-projects/Gernot/modules/index-functions.xqm';


declare function ixfn:apply-index($data as node()*, $index-name as xs:string, $x-context as xs:string, $type as xs:string?) as item()* {
switch ($x-context)
	case 'Gernot' return ixfn-Gernot:apply-index($data, $index-name, $x-context, $type)
	default return ()
};

