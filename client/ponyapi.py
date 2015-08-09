import requests

"""
# PonyAPI module for Python programs

This is written in a metaprogramming style.

Usage:

```python
import ponyapi

episodes = ponyapi.all_episodes()

for episode in episodes:
    print episode
```

Available methods:

    all_episodes() -> return all information on all episodes
    newest() -> return information on the newest episode
    random() -> return a random episode
    get_season(snum) -> return all episodes in season snum
    get_episode(snum, enum) -> return info on season snum episode enum
    search(query) -> return all episodes that have query in the title
"""

API_ENDPOINT = "http://ponyapi.apps.xeserv.us"

# _base_get :: Text -> Maybe [Text] -> (Maybe [Text] -> IO (Either Episode [Episode]))
# _base_get takes a text, a splatted list of texts and returns a function such that
#     the function takes a splatted list of texts and returns either an Episode or
#     a list of Episode as an IO action.
def _base_get(endpoint, *fragments):
    def doer(*args):
        r = None

        assert len(fragments) == len(args)

        if len(fragments) == 0:
            r = requests.get(API_ENDPOINT + endpoint)
        else:
            url = API_ENDPOINT + endpoint

            for i in range(len(fragments)):
                url = url + "/" + fragments[i] + "/" + str(args[i])

            r = requests.get(url)

        if r.status_code != 200:
            raise Exception("Not found or server error")

        try:
            return r.json()["episodes"]
        except:
            return r.json()["episode"]

    return doer

# all_episodes :: IO [Episode]
all_episodes = _base_get("/all")

# newest :: IO Episode
newest = _base_get("/newest")

# random :: IO Episode
random = _base_get("/random")

# get_season :: Int -> IO [Episode]
get_season = _base_get("", "season")

# get_episode :: Int -> Int -> IO Episode
get_episode = _base_get("", "season", "episode")

# search :: Text -> IO [Episode]
def search(query):
    params = {"q": query}
    r = requests.get(API_ENDPOINT + "/search", params=params)

    if r.status_code != 200:
        raise Exception("Not found or server error")

    return r.json()["episodes"]
