import platform
import json
import shutil
import urllib
import tarfile
import os

class FileUtil(object):

    @staticmethod
    def does_it_exist(path):
        try:
            open(path)
            return True
        except IOError as e:
            return False

class ConsoleLogger(object):
    @staticmethod
    def info(sth):
        print('info - %s' % (sth))

    @staticmethod
    def error(sth):
        print('error - %s' % (sth))

    @staticmethod
    def give_up():
        exit()


class DependenyResolver(object):
    __dependencies = None
    __depot_type = None
    __depot_location = None
    __dependency_iterator = None
    __manifest = None

    def __init__(self, manifest, depot_base):
        # parse the manifest file , then populate 
        # the file names based on the target operating system
        # then return an iterator which can be invoked by the 
        # caller to download each dependency and extract them
        # parse the manifest file
        # get the operating system information
        self.__manifest = manifest
        self.__depot_location = depot_base
        if self.__depot_location :
            if self.__depot_location.startswith('http'):
                self.__depot_type = 'http'
            else:
                self.__depot_type = 'file'


        # create a string ${name}-${tag}-${os}.tar.gz
        # then create a iterable list and add these dependencies there
        

    
    # parse the manifest file and return list of dependencies
    
    def resolve(self):
        self.__dependencies = self._parse_dependencies(open(self.__manifest).read())
        dependencies = []
        projects = self.__dependencies['projects']
        for name in projects:
            dependencies.append({'name':name,
                    'binary':projects[name]['binary']})
        ConsoleLogger.info(dependencies)
        return dependencies


    def _get_os_info(self):
        # info has 'arch', 'os', 'distribution' and 'version'
        info = {}
        info['arch'] = platform.machine()
        os_string = platform.platform().lower()
        if os_string.startswith('darwin') and os_string.find('x86_64') >= 0:
            info['os'] = 'mac'
            info['arch'] = 'x86_64'
        elif os_string.startswith('linux'):
            info['os'] = 'linux'
            if os_string.find('i686') >= 0:
                info['arch'] = 'x86'
            elif os_string.find('x86_64') >= 0:
                info['arch'] = 'x86_64'
            if os_string.find('ubuntu') >= 0:
                info['distribution'] = 'ubuntu'
            elif os_string.find('redhat') >= 0:
                info['distribution'] = 'redhat'
        elif os_string.startswith('cygwin'):
            info['os'] = 'windows'
            if os_string.find('32-bit') >= 0:
                info['arch'] = 'x86'
            elif os_string.find('wow64') >= 0:
                info['arch'] = 'x86_64'
        return info

    
    def download(self, dependency, destination):
        ConsoleLogger.info('downloading from %s' % (self.__depot_location))
        ConsoleLogger.info('downloading %s to %s' % (dependency['binary'],
                                                     destination))
        if self.__depot_type == 'http':
            return self._download_web(dependency, destination)
        elif self.__depot_type == 'file':
            return self._download_local(dependency, destination)
        else:
            return None

    def _download_web(self, dependency, destination):
        url = '%s/%s' % (self.__depot_location, dependency['binary'])
        web = urllib.urlopen(url)
        target = '%s/%s' % (destination, dependency['binary'])
        local = open(target, 'w')
        ConsoleLogger.info('downloading %s' % (url))
        local.write(web.read())
        web.close()
        local.close()
        return target 

    def _download_local(self, dependency, destination):
        #copy the file from dependency['path'] to destination
        # check if the file exists
        source = '%s/%s' % (self.__depot_location, dependency['binary'])
        target = '%s/%s' % (destination, dependency['binary'])
        shutil.copyfile(source, target)
        return target
    

    def _extract_mac(self, file, destination):
        ConsoleLogger.info('extracting %s to %s' % (file, destination))
        os.chdir(destination)
        tar = tarfile.open(file)
        tar.extractall()
        tar.close()

    def _extract_windows(self, file, destination):
        ConsoleLogger.info('extracting %s to %s' % (file, destination))
        os.chdir(destination)
        tar = tarfile.open(file)
        tar.extractall()
        tar.close()

    def _extract_linux(self, file, destination):
        ConsoleLogger.info('extracting %s to %s' % (file, destination))
        os.chdir(destination)
        tar = tarfile.open(file)
        tar.extractall()
        tar.close()

    def extract(self, dependency, destination):
        machine = self._get_os_info()
        if machine['os'] == 'mac':
            self._extract_mac(dependency, destination)
        elif machine['os'] == 'windows':
            self._extract_windows(dependency, destination)
        elif machine['os'] == 'linux':
            self._extract_linux(dependency, destination)
        #extract the dependency to the target location
        else:
            #raise NotSupportedPlatformException()
            return None

    def __decode_list(self, data):
        rv = []
        for item in data:
            if isinstance(item, unicode):
                item = item.encode('utf-8')
            elif isinstance(item, list):
                item = self.__decode_list(item)
            elif isinstance(item, dict):
                item = self._decode_dict(item)
            rv.append(item)
        return rv

    def __decode_dict(self, data):
        rv = {}
        for key, value in data.iteritems():
            if isinstance(key, unicode):
                key = key.encode('utf-8')
            if isinstance(value, unicode):
                value = value.encode('utf-8')
            elif isinstance(value, list):
                value = self.__decode_list(value)
            elif isinstance(value, dict):
                value = self.__decode_dict(value)
            rv[key] = value
        return rv    

    def _parse_dependencies(self, dependencies):
        os_info = self._get_os_info()
        dj = json.loads(dependencies, object_hook=self.__decode_dict)
        #if os and arch match and we can't find a version
        #match let's use that
        best_match = None
        for d in dj:
            os_match = d['os'] == os_info['os'] or d['os'] == os_info['distribution']
            version_match = 'version' in os_info and (d['version'] == os_info['version'])
            arch_match = d['arch'] == os_info['arch']
            if os_match and arch_match:
                best_match = d
                if version_match: 
                    return d
        return best_match
