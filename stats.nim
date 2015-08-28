import json

type
  Bucket* = object of RootObj
    ## A collection of stats
    name*: string
    fails*: int
    success*: int

proc `%`*(b: Bucket): JsonNode =
  %*
    {
      "name": b.name,
      "fails": b.fails,
      "success": b.success,
    }

var
  all* = Bucket(name: "all")
  newest* = Bucket(name: "newest")
  random* = Bucket(name: "random")
  lastAired* = Bucket(name: "lastAired")
  seasonLookup* = Bucket(name: "seasonLookup")
  episodeLookup* = Bucket(name: "episodeLookup")
  search* = Bucket(name: "search")
