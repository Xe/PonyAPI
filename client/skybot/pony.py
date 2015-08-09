from util import hook

import datetime
import ponyapi

@hook.command
def countdown(inp, say=None):
    "Shows the countdown to the new episode of My Little Pony: Friendship is Magic!"
    now = datetime.datetime(2006, 1, 1)
    now = now.now()
    ep = ponyapi.newest()
    then = now.fromtimestamp(int(ep[u"air_date"]))
    td = then-now

    seasonep = ""

    if ep[u"is_movie"]:
        seasonep = "(a movie)"
    else:
        seasonep = "(season %d episode %d)" % (ep[u"season"], ep[u"episode"])

    reply = "%s %s will air on %s in %d days!" % (
                ep[u"name"], seasonep, then.strftime("%a, %d %b %Y %H:%M:%S"),
                td.days)

    return reply

@hook.command
def randomep(inp):
    "Shows a random episode of My Little Pony: Friendship is Magic"
    ep = ponyapi.random()

    seasonep = ""

    if ep[u"is_movie"]:
        seasonep = "(a movie)"
    else:
        seasonep = "(season %d episode %d)" % (ep[u"season"], ep[u"episode"])

    return "%s %s" % (ep[u"name"], seasonep)
