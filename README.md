SADE/cr-xq-mets
===============

About SADE
----------

The Scalable Architecture for Digital Editions (SADE) tries to meet the requirement for an easy to use publication system for electronic resources and Digital Editions. It is an attempt to provide a modular concept for publishing scholarly editions in a digital medium, based on open standards. Furthermore it is a distribution of open source software tools for the easy publication of Digital Editions and digitized texts in general out of the box. SADE is a scalable system that can be adapted by different projects which follow the TEI guidelines or other XML based formats.

It is written completely in XQuery (and XSLT).

About cr-xq-mets
----------------
cr-xq-mets is a fork of SADE developed with basically the same goals, but certain changes in the system design:

* It adopts METS format for maintaining the structure of the projects.
* It supports multiple projects on one application instance
* It strictly separates between the logic, the layout, the data and the configuration
* The layout templates are maintained separately and can be reused (and customized) by the projects 
* It supports project-specific overriding of any part of the template (html-snippets, js, css)
* Currently, this fork builds as a package to be installed in an existing eXist installation, not as self-contained package including own eXist-instance as is the case in the main SADE project.

Further documentation **_[mostly outdated!]_**:

* [Overview](docs/overview.md) - overall picture of the system
* [Project](docs/cr-project.md) - conceptual about the main structuring unit
* [Configuration](docs/config.md) -  
* [Templating](docs/templating.md)


Build and install
----------------

Prerequisites: The system runs as an application on an eXist instance (which is not packaged in the build), thus you need a running eXist-instance. (Succesfully used with various 2.x versions)
[Download eXist](http://exist-db.org/exist/apps/homepage/index.html#downloads)

1. Copy build.properties.default to build.properties and edit to your needs.
Edit `build.properties`

  ```
	app.name=cr-xq-mets
  app.uri=http://vronk.net/ns/cr-xq-mets
	projects.dir=cr-projects
	data.dir=cr-data
  ```

  During build they are used to generate: 

  ```	
	repo.template -> repo.xml
	expath-pkg.template.xml -> expath-pkg.xml
	
	$projects.dir + core/config.template.xql -> config.xql
  ```
	
2. Call `ant` (with default `xar` target). This generates an `.xar` package in the `build` directory 

1. Install the generated package via package manager 

	Upon installation `setup.xql` is executed which generates the `$projects.dir`
	and sets up the default project.

Setup a project
---------------

There is currently no administrative interface for managing the project and its resources. (#8)
However there is a set of high-level functions for this purpose.

Thus for administering the cr-projects you need to go to eXide to execute these functions.

Upon installation a default project with the id `defaultProject` is automatically set up.

If you want to create a new project, use:
```
project:new('project1')
```

For every project, you need to configure 

1. permissions
1. indexes
1. UI layout
1. Other

### Permissions

The access to the project is governed by a dedicated section within the project-configuration file under 
```
/mets:mets/mets:amdSec/mets:rightsMD[@ID="projectACL"]
```

This contains ace-entries in the eXist's internal format (see module (http://exist-db.org/xquery/securitymanager))

```
<mets:rightsMD ID="projectACL" GROUPID="config.xml">
            <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="EXISTACL">
                <mets:xmlData>
                    <sm:permission xmlns:sm="http://exist-db.org/xquery/securitymanager" owner="abacusAdmin" group="abacusAdmin" mode="rwx------">
                        <sm:acl entries="2">
                            <sm:ace index="0" target="GROUP" who="other" access_type="DENIED" mode="rwx"/>
                            <sm:ace index="1" target="USER" who="prj1user" access_type="ALLOWED" mode="rwx"/>
                        </sm:acl>
                    </sm:permission>
                </mets:xmlData>
            </mets:mdWrap>
        </mets:rightsMD> 
```

The example code would make the project viewable only to the user `prj1user`. Setting first entry for `GROUP=other?` to `ALLOWED` makes the project publicly available (without any authentication needed)

The permissions are resolved in the `controller.xql` and for protected project the user without access rights is redirected to login-page

### Indexes

The system relies on abstract indexes that are mapped to corresponding XPath.
These indexes are mainly used in the `fcs` module which is the currently the core module for searching in the data.

The index mappings are defined in
```
/mets:mets/mets:amdSec/mets:techMD[@ID="projectMappings"]
```

See more details regarding [Indexes](docs/indexes.md)


### UI Layout

The system keeps the layout for the applications separately from the individual projects to enable reuse,
still allowing to customize given layout in the project-context.

The layouts are defined in the `{$APP.ROOT}/templates` collection, the name of the sub-collections being the identifier for given template/layout.

To apply given layout for given project you simply need to set the template-identifier as value in the `template`-param:
```
/mets:mets/mets:amdSec/mets:techMD[@ID="projectParameters"]//param[@key="template"]
```

The current default is `minimal`.

See more on [templating](docs/templating.md)

### Other

What you probably also want to set right away is the project title

You can set it in two ways:
a) in the main metadata record for the project (this is automatically created on project initialization) in the `cmd:Title` element 
b) in the main project-configuration METS-file unter `mets:mets/@LABEL`


Add resources
-------------
Here again, you need to work with module-function, there is no running user-interface for managing the resources.

Here we assume, that one resource is represented by one file.

1. upload a file to some temporary collection via oxygen or webdav
1. invoke `resource:new-with-label()` (see helper-script `src/sandbox_init_resource.xql`)
   This copies the data into the master-data collection of the project (`/db/cr-data/{$project-id}`)
   and adds an entry in the project configuration file.
1. optionally you may need to run `resource:refresh-aux-files()`, a function that generates internal derived files for given resource. See info on [resource](docs/resource.md) for more.
