PonyAPI Java Client
===================

A Java client for accessing PonyAPI. Requires Java 8.

Example Usage
-------------

```java
package us.xeserv.examples;

import us.xeserv.ponyapi.Episode;
import us.xeserv.ponyapi.PonyApiClient;

import java.io.IOException;
import java.time.Instant;
import java.util.List;

public class PonyApiExample {

    public static void main(String[] args) throws IOException {
        // Initialize a client with a custom API host
        PonyApiClient client = new PonyApiClient("some.fqdn.here"); // defaults to port 80
                      client = new PonyApiClient("some.fqdn.here", 8080); // with a custom port number
        // Initialize a client using http://ponyapi.apps.xeserv.us/ as the API ohst
                      client = new PonyApiClient();

        // Get a list of all the episodes
        List<Episode> allEpisodes = client.all();

        // Get the newest episode
        Episode newestEpisode = client.newest();

        // Get information about an episode
        String name = newestEpisode.name;
        Instant airDate = newestEpisode.airDate;
        int seasonNumber = newestEpisode.season;
        int episodeNumber = newestEpisode.episode;
        boolean isMovie = newestEpisode.isMovie;

        // Get all episodes in a season
        List<Episode> season = client.getSeason(1);

        // Get all movies
        List<Episode> movies = client.getMovies();

        // Get a specific episode by season and episode number
        Episode specificEpisode = client.getEpisode(1, 13);

        // Get a specific movie by movie number
        Episode specificMovie = client.getMovie(1);

        // Get a random movie or movie number
        Episode random = client.random();

        // Get a list of all episodes and movies matching a query
        List<Episode> queryResults = client.search("Owl's Well"); // returns Owl's Well That Ends Well

    }

}
```