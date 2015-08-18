package us.xeserv.ponyapi;

import org.junit.Test;

import java.io.IOException;
import java.time.Instant;
import java.util.List;

import static org.junit.Assert.*;

public class PonyApiClientTest {

    private PonyApiClient client = new PonyApiClient();

    @Test
    public void allTest() throws Exception {
        List<Episode> list = client.all();
        assertFalse(list.isEmpty());
    }

    @Test
    public void newestTest() throws IOException {
        Episode episode = client.newest();
        assertNotNull(episode);
    }

    @Test
    public void lastAiredTest() throws IOException {
        Episode episode = client.lastAired();
        assertNotNull(episode);
    }

    @Test
    public void getSeasonTest() throws IOException {
        List<Episode> list = client.getSeason(98);
        assertEquals(null, list);
        list = client.getSeason(1);
        assertEquals(26, list.size());
    }

    @Test
    public void getMoviesTest() throws IOException {
        List<Episode> list = client.getMovies();
        assertFalse(list.isEmpty());
    }

    @Test
    public void getEpisodeTest() throws IOException {
        Episode episode = client.getEpisode(1, 1);
        assertEquals("Friendship is Magic Part 1", episode.name);
        assertEquals(Instant.ofEpochSecond(1286735400), episode.airDate);
        assertEquals(1, episode.season);
        assertEquals(1, episode.episode);
        assertEquals(false, episode.isMovie);
    }

    @Test
    public void getMovieTest() throws IOException {
        Episode episode = client.getMovie(1);
        assertEquals("Equestria Girls", episode.name);
        assertEquals(Instant.ofEpochSecond(1371340800), episode.airDate);
        assertEquals(99, episode.season);
        assertEquals(1, episode.episode);
        assertEquals(true, episode.isMovie);
    }

    @Test
    public void randomTest() throws IOException {
        Episode episode = client.random();
        assertNotNull(episode);
    }

    @Test
    public void searchTest() throws IOException {
        List<Episode> episodes = client.search("Owl's Well");
        assertEquals(1, episodes.size());
        Episode episode = episodes.get(0);
        assertEquals("Owl's Well That Ends Well", episode.name);
    }

}
