import httpclient
import json

type
  Episode* = object of RootObj
    name: string
    air_date: int
    season: int
    episode: int
    is_movie: bool

const
  API_ENDPOINT: string = "http://ponyapi.apps.xeserv.us"

proc getJson(endpoint: string): json.JsonNode =
  var
    data = httpclient.getContent(API_ENDPOINT & "/" & endpoint)
    jsonTable = json.parseJson data

  return jsonTable

proc newEpisodeFromNode(data: json.JsonNode): Episode =
  Episode(name:     data["name"].getStr,
          air_date: data["air_date"].getNum.int,
          season:   data["season"].getNum.int,
          episode:  data["episode"].getNum.int,
          is_movie: data["is_movie"].getBVal)

proc newest*(): Episode =
  getJson("/newest")["episode"].newEpisodeFromNode

proc random*(): Episode =
  getJson("/random")["episode"].newEpisodeFromNode

proc get_episode*(season, episode: int): Episode =
  getJson("/season/" & $season & "/episode/" & $episode)["episode"].newEpisodeFromNode

when isMainModule:
  import unittest

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
