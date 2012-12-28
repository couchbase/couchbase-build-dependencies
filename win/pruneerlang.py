import os, re, os.path, shutil
excepts = [
    '/.*\/doc',
    '/.*\/src',
    '/.*\/examples/',
    '/.*\/include/',
    '/.*\/Install/',
    '/.*\/Uninstall/',
    '/.*\/lib\/cos/',
    '/.*\/lib\/asn1-/',
    '/.*\/lib\/docbuilder-/',
    '/.*\/lib\/edoc-/',
    '/.*\/lib\/erl_docgen-/',
    '/.*\/lib\/gs-/',
    '/.*\/lib\/ic-/',
    '/.*\/lib\/jinterface-/',
    '/.*\/lib\/megaco-/',
    '/.*\/lib\/orber-/',
    '/.*\/lib\/odbc-/',
    '/.*\/lib\/toolbar-/',
    '/.*\/lib\/tv-/',
    '/.*\/lib\/wx-/'
]

mypath = "/opt/couchbase"
for exception in excepts:
    for root, dirs, files in os.walk(mypath):
        if re.match(exception,root):
                shutil.rmtree(root)
                continue
        for file in files:
            abs_path = os.path.join(root, file)
            if re.match(exception,abs_path):
                os.remove(abs_path)
