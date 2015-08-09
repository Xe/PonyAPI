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

None yet

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

### `/all`

Returns all information about all episodes. This returns an array of Episode
objects as defined above.

### `/newest`

Returns the episode of My Little Pony: Friendship is Magic that will air next.

### `/season/<number>`

Returns all information about episodes in the given season number or a `404`
reply if no episodes could be found. To get all information about the movies
shown, set the season as `99`.

### `/season/<number>/episode/<number`

Returns all information about the episode with the given season and episode
number. If the episode cannot be found, this will return a `404`.

### `/random`

Returns a random episode record from the list of episodes.

### `/search`

This must be given a query paramater `q` containing the text to search for. Not
including this will return a `406` reply. This will search the list of episode
records for any episodes whose names match the given search terms. This is
case-insensitive. If no episodes can be found, this will return a `404` reply.
