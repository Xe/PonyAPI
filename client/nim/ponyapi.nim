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

proc newest*(): Episode =
  var
    data = getJson("/newest")["episode"]
    ep = Episode(name:     data["name"].getStr,
                 air_date: data["air_date"].getNum.int,
                 season:   data["season"].getNum.int,
                 episode:  data["episode"].getNum.int,
                 is_movie: data["is_movie"].getBVal)

  return ep

proc `$`*(ep: Episode): string =
  return "Episode:: name:" & ep.name & " season:" & $ep.season & " episode:" & $ep.episode & " air_date:" & $ep.air_date & " is_movie:" & $ep.is_movie

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
