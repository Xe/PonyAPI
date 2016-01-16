import ponyapi
import unittest

class TestPonyAPI(unittest.TestCase):
    def test_newest(self):
        try:
            ponyapi.newest()
        except:
            print "probably on hiatus"

    def test_all_episodes(self):
        assert len(ponyapi.all_episodes()) > 0

    def test_last_aired(self):
        ponyapi.last_aired()

    def test_random(self):
        ponyapi.random()

    def test_get_season(self):
        assert len(ponyapi.get_season(4)) > 0

    def test_get_episode(self):
        ponyapi.get_episode(2, 14)

    def test_searcn(self):
        assert len(ponyapi.search("pony")) > 0

if __name__ == '__main__':
    unittest.main()
