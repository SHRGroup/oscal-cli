# oscal-cli Docker Image

Rebuilds the project from maven, and includes it in a docker image.

Chose to rebuild from source rather than using the available releases to eventually support code and security scanning

https://github.com/usnistgov/oscal-cli/

## Building

Build the docker image, (the `-f Dockerfile` is not necessary, but included to be explicit)
`RELEASE` must correspond to a tag at https://github.com/usnistgov/oscal-cli/

`docker build -f Dockerfile --build-arg RELEASE=0.2.0 -t oscal-cli:0.2.0 .`

If desired you can retag to whatever registry you would like to push to
`docker tag oscal-cli:0.2.0 matthewruge/oscal-cli:0.2.0`
`docker push matthewruge/oscal-cli:0.2.0`

## Using

The entrypoint is set to the oscal-cli executable.  The container expects any OSCAL files to be mounted at /WORKING

Please mount the desired directory there.  For example 
```
docker run -it -v $PWD/oscal-content/examples/catalog/xml:/WORKING 
```

Add any additional arguments to the command per the oscal-cli help page

```
docker run -it -v /home/matthew/git/oscal-cli/oscal-content/examples/catalog/xml:/WORKING oscal-cli:0.2.0 catalog convert --to json basic-catalog.xml
```

Examples
```bash
$ docker run -it -v $PWD/oscal-content/examples/catalog/xml:/WORKING oscal-cli:0.2.0 --version
oscal-cli version 0.2.0 built on 2022-08-23 14:40 on commit c52dcdb
OSCAL version v1.0.4 on commit c4de2fe
```

```bash
$ docker run -it -v $PWD/oscal-content/examples/catalog/xml:/WORKING oscal-cli:0.2.0 --help
usage: oscal-cli <command> [<options>]
 -h,--help               display this help message
    --no-color           do not colorize output
 -q,--quiet              minimize output to include only errors
    --show-stack-trace   display the stack trace associated with an error
    --version            display the application version

The following are available commands:
   catalog              Perform an operation on an OSCAL Catalog
   profile              Perform an operation on an OSCAL Profile
   component-definition Perform an operation on an OSCAL Component Definition
   ssp                  Perform an operation on an OSCAL System Security Plan
   ap                   Perform an operation on an OSCAL Assessment Plan
   ar                   Perform an operation on an OSCAL Assessment Results
   poam                 Perform an operation on an OSCAL Plan of Actions and Milestones
   metaschema           Perform an operation on a Metaschema

'oscal-cli <command> --help' will show help on that specific command.
```

## License 

Only this Dockerfile is licensed as Apache 2.0 for commonality with other projects.  

The OSCAL-CLI license is available at source code's license is available at https://github.com/usnistgov/oscal-cli/blob/v0.2.0/LICENSE.md