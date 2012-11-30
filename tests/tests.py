import sys
import unittest
import tempfile

sys.path.append("../")
import os
from dependencyutil import DependenyResolver, ConsoleLogger


class DependencyResolverTest(unittest.TestCase):

    def test_basic(self):
        manifest = 'test-dependencies.json'
        depot_location = '/space/2013'
        temp_location1 = tempfile.mkdtemp()
        temp_location2 = tempfile.mkdtemp()
        dr = DependenyResolver(manifest, depot_location)
        ds = dr.resolve()
        #create a temp folder
        os.tmpfile()
        for d in ds:
            downloaded = dr.download(d,temp_location1)
            extracted = dr.extract(downloaded,temp_location2)
            ConsoleLogger.info(downloaded)
            ConsoleLogger.info(extracted)

