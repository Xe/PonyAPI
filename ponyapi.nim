import asyncdispatch
import jester
import json
import strutils

type
  Episode* = object of RootObj
    ## An episode of My Little Pony: Friendship is Magic
    name*: string   ## Episode name
    air_date*: int  ## Air date in unix time
    season*: int    ## season number of the episode
    episode*: int   ## the episode number in the season
    is_movie*: bool ## does this record represent a movie?

var
  episodes: seq[Episode]

for line in lines "./fim.list":
  var
    ep: Episode
    splitLine = line.split " "
    timestr = splitLine[1]
    seasonstr = splitLine[2]
    episodestr = splitLine[3]
    is_movie = seasonstr == "99"
    name = splitLine[4 .. ^1].join " "

  ep = Episode(name: name,
               air_date: timestr.parseInt,
               season: seasonstr.parseInt,
               episode: episodestr.parseInt,
               is_movie: is_movie)

  episodes = episodes & ep

proc `%`(ep: Episode): JsonNode =
  %*
    {
      "name": ep.name,
      "air_date": ep.air_date,
      "season": ep.season,
      "episode": ep.episode,
      "is_movie": ep.is_movie,
    }

proc `%`(eps: seq[Episode]): JsonNode =
  var ret = newJArray()

  for ep in episodes:
    add ret, %ep

  ret

settings:
  port = 5000.Port
  bindAddr = "0.0.0.0"

routes:
  get "/":
    "http://github.com/Xe/PonyAPI".uri.redirect

  get "/all":
    let headers = {"Content-Type": "application/json"}
    var rep = %*
      {
        "episodes": episodes,
      }

    resp Http200, headers, pretty(rep, 4)

runForever()
