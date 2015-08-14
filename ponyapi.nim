import asyncdispatch
import future
import jester
import json
import random
import strutils
import times

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
  result = newJArray()

  for ep in eps:
    add result, %ep

proc `%%`(ep: Episode): JsonNode =
  %*
    {
      "episode": ep,
    }

proc `%%`(eps: seq[Episode]): JsonNode =
  %*
    {
      "episodes": eps,
    }

let myHeaders = {
  "Content-Type": "application/json",
  "X-Powered-By": "Nim and Jester",
}

settings:
  port = 5000.Port
  bindAddr = "0.0.0.0"

routes:
  get "/":
    "http://github.com/Xe/PonyAPI".uri.redirect

  get "/all":
    resp Http200, myHeaders, pretty(%%episodes, 4)

  get "/newest":
    var
      now = getTime()
      ep: Episode

    for episode in episodes:
      var then = times.fromSeconds(episode.air_date)

      if now < then:
        ep = episode
        break

    resp Http200, myHeaders, pretty(%%ep, 4)

  get "/random":
    resp Http200, myHeaders, pretty(%%episodes.randomChoice(), 4)

  get "/season/@snumber":
    var
      season: int = @"snumber".parseInt
      eps: seq[Episode] = lc[x | (x <- episodes, x.season == season), Episode]

    if eps.len == 0:
      resp Http404, myHeaders, $ %* { "error": "No episodes found" }
    else:
      resp Http200, myHeaders, pretty(%%eps, 4)

  get "/season/@snumber/episode/@epnumber":
    var
      season: int = @"snumber".parseInt
      enumber: int = @"epnumber".parseInt
      ep: Episode

    for episode in episodes:
      if episode.season == season:
        if episode.episode == enumber:
          ep = episode

    if ep.air_date == 0:
      resp Http404, myHeaders, $ %* {"error": "No such episode"}
    else:
      resp Http200, myHeaders, pretty(%%ep, 4)

  get "/search":
    var
      query = @"q".toLower

    if query == "":
      halt Http406, myHeaders, $ %* { "error": "Need to specify query" }

    var
      eps: seq[Episode] =
        lc[x | (x <- episodes, x.name.toLower.contains query), Episode]

    if eps.len == 0:
      resp Http404, myHeaders, $ %* { "error": "No episodes found" }
    else:
      resp Http200, myHeaders, pretty(%%eps, 4)

runForever()
