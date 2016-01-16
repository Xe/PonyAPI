package ponyapi

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
)

const (
	endpoint = "https://ponyapi.apps.xeserv.us"
)

func getJson(fragment string) (data []byte, err error) {
	c := &http.Client{}

	req, err := http.NewRequest("GET", endpoint+fragment, nil)
	if err != nil {
		return nil, err
	}

	//req.Header.Add("X-API-Options", "bare")

	resp, err := c.Do(req)

	data, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	return
}

func getEpisode(fragment string) (*Episode, error) {
	data, err := getJson(fragment)
	if err != nil {
		return nil, err
	}

	ewr := &episodeWrapper{}
	err = json.Unmarshal(data, ewr)
	if err != nil {
		return nil, err
	}

	return ewr.Episode, nil
}

func getEpisodes(fragment string) ([]*Episode, error) {
	data, err := getJson(fragment)
	if err != nil {
		return nil, err
	}

	eswr := &episodes{}
	err = json.Unmarshal(data, eswr)
	if err != nil {
		return nil, err
	}

	return eswr.Episodes, nil
}

// Newest returns information on the newest episode or an error.
func Newest() (*Episode, error) {
	return getEpisode("/newest")
}

// LastAired returns information on the most recently aried episode
// or an error.
func LastAired() (*Episode, error) {
	return getEpisode("/last_aired")
}

// Random returns information on a random episode.
func Random() (*Episode, error) {
	return getEpisode("/random")
}

// GetEpisode gets information about season x episode y or an error.
func GetEpisode(season, episode int) (*Episode, error) {
	return getEpisode(fmt.Sprintf("/season/%d/episode/%d", season, episode))
}

// AllEpisodes gets all information on all episodes or returns an error.
func AllEpisodes() ([]*Episode, error) {
	return getEpisodes("/all")
}

// GetSeason returns all information on season x or returns an error.
func GetSeason(season int) ([]*Episode, error) {
	return getEpisodes(fmt.Sprintf("/season/%d", season))
}

// Search takes the give search terms and uses that to search the
// list of episodes.
func Search(query string) ([]*Episode, error) {
	path, err := url.Parse("/search")
	if err != nil {
		panic(err)
	}

	q := path.Query()
	q.Set("q", query)

	path.RawQuery = q.Encode()

	return getEpisodes(path.String())
}
