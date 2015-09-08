PonyAPI
=======

A simple API for episodes of My Little Pony: Friendship is Magic to be run
inside a container.

API Usage
---------

An episode will have the following data type:

```json
{
      "air_date": 1286735400,
      "episode": 1,
      "is_movie": false,
      "name": "Friendship is Magic Part 1",
      "season": 1
}
```

This represents Season 1, Episode 1 of My Little Pony: Friendship Is Magic. The
`air_date` column represents the date and time that the episode was originally
shown on The Hub (now Discovery Family Network). If `is_movie` is set and the
season number is `99`, the episode record should be treated as a movie.

Usage Limits
------------

None. Don't make the server it's running on crash and we'll all be good.

Clients
-------

- [Go](https://godoc.org/github.com/Xe/PonyAPI/client/go)
- [Nim](https://github.com/Xe/PonyAPI/blob/master/client/nim/ponyapi.nim) [Docs](http://ponyapi.apps.xeserv.us/static/nim.html)
- [Python](https://github.com/Xe/PonyAPI/blob/master/client/python/ponyapi.py)
- [Java](https://github.com/Xe/PonyAPI/tree/master/client/java)

Routes
------

The canonical route base for PonyAPI is http://ponyapi.apps.xeserv.us. Example
usage:

```console
$ curl http://ponyapi.apps.xeserv.us/season/1/episode/1
{
  "episode": {
    "air_date": 1286735400,
    "episode": 1,
    "is_movie": false,
    "name": "Friendship is Magic Part 1",
    "season": 1
  }
}
```

Bare Replies
------------

As of [882b5b1](https://github.com/Xe/PonyAPI/commit/882b5b155157d3a3c9e329fffcf7ff3fdf64d4ee),
PonyAPI will accept an `X-API-Options` header that when set to `bare` will 
return the API replies without the `episode` or `episodes` header. 
Functionality is otherwise unchanged, however an error will still be shown if 
something goes wrong, and that will parse differently. This API will return 
`200` if and **only** if everything went to plan.

An example:

```console
$ curl --header "X-API-Options: bare" http://ponyapi.apps.xeserv.us/last_aired
{
    "name": "Do Princesses Dream of Magic Sheep?",
    "air_date": 1436628600,
    "season": 5,
    "episode": 13,
    "is_movie": false
}
```

This will also be triggered if you set the query parameter `options` to `bare`.

### `/all`

Returns all information about all episodes. This returns an array of Episode
objects as defined above.

### `/newest`

Returns the episode of My Little Pony: Friendship is Magic that will air next.

### `/last_aired`

Returns the episode of My Little Pony: Friendship is Magic that most recently
aired.

### `/season/<number>`

Returns all information about episodes in the given season number or a `404`
reply if no episodes could be found. To get all information about the movies
shown, set the season as `99`.

### `/season/<number>/episode/<number>`

Returns all information about the episode with the given season and episode
number. If the episode cannot be found, this will return a `404`.

### `/random`

Returns a random episode record from the list of episodes.

### `/search`

This must be given a query paramater `q` containing the text to search for. Not
including this will return a `406` reply. This will search the list of episode
records for any episodes whose names match the given search terms. This is
case-insensitive. If no episodes can be found, this will return a `404` reply.
