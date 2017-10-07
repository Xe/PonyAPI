import asyncdispatch, ponyapipkg/episode, future, httpcore, jester,
       json, os, random, ponyapipkg/stats, strutils, times

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

proc `%%`(ep: Episode): JsonNode =
  ## Pack an episode for PonyAPI clients.
  %*
    {
      "episode": ep,
    }

proc `%%`(eps: seq[Episode]): JsonNode =
  ## Pack a sequence of episodes to a JsonNode for PonyAPI clients.
  %*
    {
      "episodes": eps,
    }

proc `%%`(why: string): JsonNode =
  ## Make an error object
  %*
    {
      "error": why
    }

proc `%`(why: string): JsonNode =
  %%why

template httpReply(code, body: expr): expr =
  ## Make things a lot simpler for replies, etc.
  if request.headers.getOrDefault("X-API-Options") == "bare" or @"options" == "bare":
    # New "bare" reply format, easier to scrape, etc.
    resp code, pretty(%body, 4), "application/json"
  else:
    resp code, pretty(%%body, 4), "application/json"

settings:
  port = 5000.Port
  bindAddr = "0.0.0.0"

routes:
  get "/":
    "http://github.com/Xe/PonyAPI".uri.redirect

  get "/all":
    stats.all.success.inc
    httpReply Http200, episodes

  get "/newest":
    var
      now = getTime()
      ep: Episode

    for episode in episodes:
      var then = times.fromSeconds(episode.air_date)

      if now < then:
        ep = episode
        break

    if ep.season == 0:
      stats.newest.fails.inc
      halt Http404, "No new episode found, hiatus?"

    stats.newest.success.inc
    httpReply Http200, ep

  get "/random":
    stats.newest.success.inc
    httpReply Http200, episodes[epochTime().int mod len(episodes)]

  get "/last_aired":
    var
      now = getTime()
      ep: Episode

    for epid, episode in pairs[Episode](episodes):
      var then = times.fromSeconds(episode.air_date)

      if now < then:
        ep = episodes[epid-1]
        break

    stats.lastAired.success.inc
    httpReply Http200, ep

  get "/season/@snumber":
    var
      season: int = @"snumber".parseInt
      eps: seq[Episode] = lc[x | (x <- episodes, x.season == season), Episode]

    if eps.len == 0:
      stats.seasonLookup.fails.inc
      httpReply Http404, "No episodes found"
    else:
      stats.seasonLookup.success.inc
      httpReply Http200, eps

  get "/season/@snumber/episode/@epnumber":
    var
      season: int = @"snumber".parseInt
      enumber: int = @"epnumber".parseInt
      ep: Episode

    for episode in episodes:
      if episode.season == season:
        if episode.episode == enumber:
          ep = episode

    if @"format" == "irccmd":
      let
        irccmd = "/cs episode del $1 $2\n/cs episode add $1 $2 $3 $4" % [$ep.season, $ep.episode, $ep.air_date, ep.name]
      halt Http200, irccmd

    if ep.air_date == 0:
      stats.episodeLookup.fails.inc
      httpReply Http404, "Not found"
    else:
      stats.episodeLookup.success.inc
      httpReply Http200, ep

  get "/search":
    var
      query = @"q".toLower

    if query == "":
      stats.search.fails.inc
      halt Http406, pretty(%%"Need to specify a query", 4)

    var
      eps: seq[Episode] =
        lc[x | (x <- episodes, x.name.toLower.contains query), Episode]

    if eps.len == 0:
      stats.search.fails.inc
      httpReply Http404, "No episodes found"
    else:
      stats.search.success.inc
      httpReply Http200, eps

  get "/_stats":
    resp Http200, pretty(%*
      [
        stats.all,
        stats.newest,
        stats.random,
        stats.lastAired,
        stats.seasonLookup,
        stats.episodeLookup,
        stats.search,
      ], 4)

when isMainModule:
  runForever()
else:
  quit "This should not be called outside of being the main module"
