# ponyapi

    import "github.com/Xe/PonyAPI/client/go"

Package ponyapi provides glue for applications written in Go that want to use
PonyAPI for getting information.

## Usage

#### type Episode

```go
type Episode struct {
	AirDate int    `json:"air_date"`
	Episode int    `json:"episode"`
	IsMovie bool   `json:"is_movie"`
	Name    string `json:"name"`
	Season  int    `json:"season"`
}
```

Episode is an episode of My Little Pony: Friendship is Magic.

#### func  GetEpisode

```go
func GetEpisode(season, episode int) (*Episode, error)
```
GetEpisode gets information about season x episode y or an error.

#### func  Newest

```go
func Newest() (*Episode, error)
```
Newest returns information on the newest episode or an error.

#### func  Random

```go
func Random() (*Episode, error)
```
Random returns information on a random episode.

#### func  AllEpisodes

```go
func AllEpisodes() ([]*Episode, error)
```
AllEpisodes gets all information on all episodes or returns an error.

#### func  GetSeason

```go
func GetSeason(season int) ([]*Episode, error)
```
GetSeason returns all information on season x or returns an error.

#### func  Search

```go
func Search(query string) ([]*Episode, error)
```
Search takes the give search terms and uses that to search the list of 
episodes.
