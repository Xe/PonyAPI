package ponyapi

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
)

const (
	endpoint = "http://ponyapi.apps.xeserv.us"
)

func getJson(fragment string) (data []byte, err error) {
	resp, err := http.Get(endpoint + fragment)
	if err != nil {
		return nil, err
	}

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

func Newest() (*Episode, error) {
	return getEpisode("/newest")
}

func Random() (*Episode, error) {
	return getEpisode("/random")
}

func GetEpisode(season, episode int) (*Episode, error) {
	return getEpisode(fmt.Sprintf("/season/%d/episode/%d", season, episode))
}

func AllEpisodes() ([]*Episode, error) {
	return getEpisodes("/all")
}

func GetSeason(season int) ([]*Episode, error) {
	return getEpisodes(fmt.Sprintf("/season/%d", season))
}

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
