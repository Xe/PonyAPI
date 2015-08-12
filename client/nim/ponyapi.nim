import cgi
import httpclient
import json

## A bunch of glue for Nim applications to query PonyAPI.

type
  Episode* = object of RootObj
    ## An episode of My Little Pony: Friendship is Magic
    name*: string   ## Episode name
    air_date*: int  ## Air date in unix time
    season*: int    ## season number of the episode
    episode*: int   ## the episode number in the season
    is_movie*: bool ## does this record represent a movie?

const
  API_ENDPOINT: string = "http://ponyapi.apps.xeserv.us"

proc getJson(endpoint: string): json.JsonNode =
  ## get the HTTP body for the API base endpoint catted with the specific endpoint
  ## requested.
  var
    data = httpclient.getContent(API_ENDPOINT & "/" & endpoint)

  data.parseJson

proc newEpisodeFromNode(data: json.JsonNode): Episode =
  ## Convert a json node into an episode object
  Episode(name:     data["name"].getStr,
          air_date: data["air_date"].getNum.int,
          season:   data["season"].getNum.int,
          episode:  data["episode"].getNum.int,
          is_movie: data["is_movie"].getBVal)

proc newEpisodeListFromNode(data: json.JsonNode): seq[Episode] =
  ## Convert a json array into a sequence of episode objects
  var ret: seq[Episode]
  for item in data.items():
    ret = ret & item.newEpisodeFromNode

  return ret

proc newest*(): Episode =
  ## returns information on the newest episode of My Little Pony: Friendship is Magic.
  getJson("/newest")["episode"].newEpisodeFromNode

proc random*(): Episode =
  ## returns information on a random episode.
  getJson("/random")["episode"].newEpisodeFromNode

proc get_episode*(season, episode: int): Episode =
  ## return an arbitrary episode by season, episode pair.
  getJson("/season/" & $season & "/episode/" & $episode)["episode"].newEpisodeFromNode

proc all_episodes*(): seq[Episode] =
  ## return all information on all episodes.
  getJson("/all")["episodes"].newEpisodeListFromNode

proc get_season*(season: int): seq[Episode] =
  ## return all information on a single season.
  getJson("/season/" & $season)["episodes"].newEpisodeListFromNode

proc search*(term: string): seq[Episode] =
  ## searches for episodes by the given query term.
  getJson("/search?q=" & term.encodeURL())["episodes"].newEpisodeListFromNode

when isMainModule:
  import unittest

  echo "Running API tests"

  suite "ponyapi tests":
    var ep: Episode

    test "Newest episode lookup":
      try:
        ep = newest()

      except:
        echo getCurrentExceptionMsg()
        fail

    test "stringify episode":
      echo ep

    test "random episode":
      echo random()

    test "get episode":
      var myEp = get_episode(2, 14) # best episode
      assert myEp.name == "The Last Roundup"

    test "get all episodes":
      try:
        var all = all_episodes()
        assert all.len > 100

      except:
        echo getCurrentExceptionMsg()
        fail

    test "get information on season 1":
      try:
        var eps = get_season(1)

        assert eps.len == 26

      except:
        echo getCurrentExceptionMsg()
        fail

    test "search for pony":
      try:
        var eps = search("pony")

        assert eps.len > 0

      except:
        echo getCurrentExceptionMsg()
        fail

