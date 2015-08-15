import json

type
  Episode* = object of RootObj
    ## An episode of My Little Pony: Friendship is Magic
    name*: string   ## Episode name
    air_date*: int  ## Air date in unix time
    season*: int    ## season number of the episode
    episode*: int   ## the episode number in the season
    is_movie*: bool ## does this record represent a movie?

proc `%`*(ep: Episode): JsonNode =
  ## Convert an Episode record to a JsonNode
  %*
    {
      "name": ep.name,
      "air_date": ep.air_date,
      "season": ep.season,
      "episode": ep.episode,
      "is_movie": ep.is_movie,
    }

proc `%`*(eps: seq[Episode]): JsonNode =
  ## Convert a sequence of episodes to a JsonNode
  result = newJArray()

  for ep in eps:
    add result, %ep

proc newEpisodeFromNode*(data: json.JsonNode): Episode =
  ## Convert a json node into an episode object
  Episode(name:     data["name"].getStr,
          air_date: data["air_date"].getNum.int,
          season:   data["season"].getNum.int,
          episode:  data["episode"].getNum.int,
          is_movie: data["is_movie"].getBVal)

proc newEpisodeListFromNode*(data: json.JsonNode): seq[Episode] =
  ## Convert a json array into a sequence of episode objects
  var ret: seq[Episode]
  for item in data.items():
    ret = ret & item.newEpisodeFromNode

  return ret
