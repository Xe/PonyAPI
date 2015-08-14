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

echo episodes
