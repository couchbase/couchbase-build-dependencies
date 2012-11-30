# usage install-dependencies.py --manifest=abc.xml --depot-location=.... --target=... --install=...

import sys
from optparse import OptionParser
from dependencyutil import DependenyResolver, FileUtil, ConsoleLogger

def give_up():
    sys.exit()


parser = OptionParser()

parser.add_option('-m', '--manifest', dest='manifest',
                  default='dependencies.json',
                  help='manifest file for all dependencies')

parser.add_option('-d', '--depot', dest='depot',
                  default='http://builds.hq.northscale.net/dependencies/couchbase-server-2.0/',
                  help='depot location')
parser.add_option('-t', '--target', dest='target',
                  help='download depenencies to this location')
parser.add_option('-i', '--install', dest='install',
                  default='/opt/couchbase',
                  help='extract the dependencies into this folder ( default = /opt/couchbase')

options, args = parser.parse_args()

if not options.manifest:
    ConsoleLogger.error('you need to specify the manifest file via -m option , e.g -m dependencies.xml')
    parser.print_help()
    give_up()

if not FileUtil.does_it_exist(options.manifest):
    ConsoleLogger.error('specified manifest : %s does not exist' % (options.manifest))
    give_up()

if not options.depot:
    ConsoleLogger.info('depot location (-d) is not specified , choosing the default')
    options.depot = 'http://...'
    give_up()

if not options.target:
    default_target =  '' # working directory/dependencies
    ConsoleLogger.info('target location is not specified , choosing the default to %s' %
         ( default_target))
    options.target = default_target

resolver = DependenyResolver(options.manifest, options.depot)
dependencyIter = resolver.resolve()
for dependency in dependencyIter:
    downloaded = resolver.download(dependency, options.target)
    resolver.extract(downloaded, options.install)