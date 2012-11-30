couchbase-build-dependencies

usage :

python ./install-deps.py  -i /opt/couchbase -t /tmp/

this tool detects which operating system the user runs this tool on and finds the best
match based on the projects listed in the dependencies.json file

by default this tool downloads the dependencies from web location but if you
want to override the web location with local directory you can use -d option

all the dependencies are built with /opt/couchbase as prefix

for each dependencies you will also find a build-* file which describes the steps that
the build engineer or developers need to follow in order to generate those binaries from
the source code.