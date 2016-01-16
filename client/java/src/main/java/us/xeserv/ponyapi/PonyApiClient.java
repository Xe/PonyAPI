package us.xeserv.ponyapi;

import com.google.common.base.Strings;
import org.apache.http.HttpResponse;
import org.apache.http.client.fluent.Request;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

/**
 * The {@code PonyApiClient} class provides an interface between Java code that uses this library and PonyAPI.
 * <p>
 * This client is able to retrieve information about the show My Little Pony: Friendship is Magic.
 *
 * @author Justin Kaufman
 * @since 1.0
 */
public class PonyApiClient {

    private final String host;

    /**
     * The default constructor initializes a client instance that uses http://ponyapi.apps.xeserv.us/ as the API source.
     */
    public PonyApiClient() {
        this("ponyapi.apps.xeserv.us");
    }

    /**
     * Accepts a FQDN and port running the PonyAPI service on a specified port.
     * @param host a FQDN running the PonyAPI service
     * @param port the port the PonyAPI service is running on
     */
    public PonyApiClient(String host, int port) {
        this.host = host + ":" + port;
    }

    /**
     * Accepts a FQDN running the PonyAPI service on port 80.
     * @param host a FQDN running the PonyAPI service
     */
    public PonyApiClient(String host) {
        this.host = host;
    }

    /**
     * Returns a list of all episodes and movies.
     * @return a list of all episodes and movies
     * @throws IOException if there is an error accessing the service
     */
    public List<Episode> all() throws IOException {
        return JsonDecoder.listFromJson(asJson(get("/all")));
    }

    /**
     * Returns the newest episode or movie aired.
     * @return the newest episode or movie aired
     * @throws IOException if there is an error accessing the service
     */
    public Episode newest() throws IOException {
        return JsonDecoder.fromJson(asJson(get("/newest")));
    }

    /**
     * Returns the episode or movie that most recently aired.
     * @return the episode or movie that most recently aired
     * @throws IOException if there is an error accessing the service
     */
    public Episode lastAired() throws IOException {
        return JsonDecoder.fromJson(asJson(get("/last_aired")));
    }

    /**
     * Returns all information about episodes in a given season number.
     * @param season the season number
     * @return all information about episodes in a given season number
     * @throws IOException  if there is an error accessing the service
     */
    public List<Episode> getSeason(int season) throws IOException {
        HttpResponse response = get("/season/" + season);
        if (statusCode(response) == 404) {
            return null;
        }
        return JsonDecoder.listFromJson(asJson(response));
    }

    /**
     * Returns all information about movies.
     * @return all information about movies
     * @throws IOException if there is an error accessing the service
     */
    public List<Episode> getMovies() throws IOException {
        return JsonDecoder.listFromJson(asJson(get("/season/99")));
    }

    /**
     * Returns all information about the episode with the given season and episode number.
     * @param season the season number
     * @param episode the episode number
     * @return all information about the episode with the given season and episode number
     * @throws IOException if there is an error accessing the service
     */
    public Episode getEpisode(int season, int episode) throws IOException {
        HttpResponse response = get("/season/" + season + "/episode/" + episode);
        if (statusCode(response) == 404) {
            return null;
        }
        return JsonDecoder.fromJson(asJson(response));
    }

    /**
     * Returns all information about the movie with the given movie number.
     * @param movie the movie number
     * @return all information about the movie with the given movie number
     * @throws IOException if there is an error accessing the service
     */
    public Episode getMovie(int movie) throws IOException {
        HttpResponse response = get("/season/99/episode/" + movie);
        if (statusCode(response) == 404) {
            return null;
        }
        return JsonDecoder.fromJson(asJson(response));
    }

    /**
     * Returns a random episode or movie from the record.
     * @return a random episode or movie from the record
     * @throws IOException if there is an error accessing the service
     */
    public Episode random() throws IOException {
        String json = asJson(get("/random"));
        return JsonDecoder.fromJson(json);
    }

    /**
     * Returns a list of episodes which contain the query in its name.
     * @param query a case-independent, non-empty {@code String}
     * @return a list of episodes which contain the query in its name
     * @throws IOException if there is an error accessing the service
     * @throws IllegalArgumentException if the query is null or empty
     */
    public List<Episode> search(String query) throws IOException {
        if (Strings.isNullOrEmpty(query)) {
            throw new IllegalArgumentException("A search query is required.");
        }
        HttpResponse response = get("/search?q=" + URLEncoder.encode(query, "UTF-8"));
        if (statusCode(response) == 404) {
            return null;
        }
        return JsonDecoder.listFromJson(asJson(response));
    }

    private HttpResponse get(String path) throws IOException {
        return Request.Get("https://" + host + path)
                .userAgent("PonyApi Java Client 1.0")
                .execute()
                .returnResponse();
    }

    private String asJson(HttpResponse response) throws IOException {
        return EntityUtils.toString(response.getEntity());
    }

    private int statusCode(HttpResponse response) throws IOException {
        return response.getStatusLine().getStatusCode();
    }

}
