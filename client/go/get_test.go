package ponyapi

import "testing"

func TestNewestEpisode(t *testing.T) {
	ep, err := Newest()
	if err != nil {
		//		t.Fatal(err)
	}

	t.Logf("%#v", ep)
}

func TestLastAiredEpisode(t *testing.T) {
	ep, err := LastAired()
	if err != nil {
		t.Fatal(err)
	}

	t.Logf("%#v", ep)
}

func TestRandomEpisode(t *testing.T) {
	ep, err := Random()
	if err != nil {
		t.Fatal(err)
	}

	t.Logf("%#v", ep)
}

func TestSpecificEpisode(t *testing.T) {
	ep, err := GetEpisode(2, 24)
	if err != nil {
		t.Fatal(err)
	}

	t.Logf("%#v", ep)
}

func TestAllEpisodes(t *testing.T) {
	eps, err := AllEpisodes()
	if err != nil {
		t.Fatal(err)
	}

	t.Logf("%d episodes", len(eps))
}

func TestGetSeason(t *testing.T) {
	eps, err := GetSeason(4)
	if err != nil {
		t.Fatal(err)
	}

	t.Logf("%d episodes", len(eps))
}

func TestSearch(t *testing.T) {
	eps, err := Search("pony")
	if err != nil {
		t.Fatal(err)
	}

	t.Logf("%#v", eps)
}
