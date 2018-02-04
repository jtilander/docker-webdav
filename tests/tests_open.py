import unittest
import requests
# from pprint import pprint


class TestBasics(unittest.TestCase):
    def test_connect(self):
        r = requests.get('http://webdav/')
        self.assertEqual(200, r.status_code)

    def test_nonexistentdir(self):
        r = requests.get('http://webdav/no_such_dir/')
        self.assertEqual(404, r.status_code)

    def test_nonexistentfile(self):
        r = requests.get('http://webdav/no_such_file')
        self.assertEqual(404, r.status_code)

    def test_upload(self):
        with open('/tmp/zero.bin') as f:
            r = requests.put('http://webdav/upload/zero.bin', files={'file': f})
            self.assertEqual(201, r.status_code)
        self.assertEqual(1, len(requests.get('http://webdav/upload/').json()))

    def test_get(self):
        with open('/tmp/zero.bin') as f:
            r = requests.put('http://webdav/get/zero.bin', files={'file': f})
        r = requests.get('http://webdav/get/zero.bin')
        self.assertEqual(200, r.status_code)

    def test_delete(self):
        with open('/tmp/zero.bin') as f:
            r = requests.put('http://webdav/delete/zero.bin', files={'file': f})
        r = requests.delete('http://webdav/delete/zero.bin')
        self.assertEqual(204, r.status_code)
        r = requests.get('http://webdav/delete/zero.bin')
        self.assertEqual(404, r.status_code)
