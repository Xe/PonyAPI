package us.xeserv.ponyapi;

import org.junit.Test;

import java.time.Instant;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

public class JsonDecoderTest {

    @Test
    public void malformedInputTest() {
        assertNull(JsonDecoder.fromJson(null));
        assertNull(JsonDecoder.fromJson(""));
        assertNull(JsonDecoder.fromJson("{ \"error\": { \"msg\": \"some error\", \"code\": 404 }"));
    }

    @Test
    public void episodeTest() {
        String json = "{\n"
                + "\t\"episode\":\n"
                + "\t{\n"
                + "\t\t\"name\": \"Friendship is Magic Part 1\",\n"
                + "\t\t\"air_date\": 1286735400,\n"
                + "\t\t\"season\": 1,\n"
                + "\t\t\"episode\": 1,\n"
                + "\t\t\"is_movie\": false\n"
                + "\t}\n"
                + "}";

        Episode episode = JsonDecoder.fromJson(json);
        assertEquals("Friendship is Magic Part 1", episode.name);
        assertEquals(Instant.ofEpochSecond(1286735400), episode.airDate);
        assertEquals(1, episode.season);
        assertEquals(1, episode.episode);
        assertEquals(false, episode.isMovie);
    }

    @Test
    public void movieTest() {
        String json = "{\n"
                + "\t\"episode\":\n"
                + "\t{\n"
                + "\t\t\"name\": \"Equestria Girls\",\n"
                + "\t\t\"air_date\": 1371340800,\n"
                + "\t\t\"season\": 99,\n"
                + "\t\t\"episode\": 1,\n"
                + "\t\t\"is_movie\": true\n"
                + "\t}\n"
                + "}";

        Episode episode = JsonDecoder.fromJson(json);
        assertEquals("Equestria Girls", episode.name);
        assertEquals(Instant.ofEpochSecond(1371340800), episode.airDate);
        assertEquals(99, episode.season);
        assertEquals(1, episode.episode);
        assertEquals(true, episode.isMovie);
    }

    @Test
    public void multipleMalformedInputTest() {
        assertNull(JsonDecoder.listFromJson(null));
        assertNull(JsonDecoder.listFromJson(""));
        assertNull(JsonDecoder.listFromJson("{ \"error\": { \"msg\": \"some error\", \"code\": 404 }"));
    }

    @Test
    public void multipleTest() {
        String json = "{\n"
                + "\t\"episodes\": [\n"
                + "\t\t{\n"
                + "\t\t\t\"name\": \"Friendship is Magic Part 1\",\n"
                + "\t\t\t\"air_date\": 1286735400,\n"
                + "\t\t\t\"season\": 1,\n"
                + "\t\t\t\"episode\": 1,\n"
                + "\t\t\t\"is_movie\": false\n"
                + "\t\t},\n"
                + "\t\t{\n"
                + "\t\t\t\"name\": \"Equestria Girls\",\n"
                + "\t\t\t\"air_date\": 1371340800,\n"
                + "\t\t\t\"season\": 99,\n"
                + "\t\t\t\"episode\": 1,\n"
                + "\t\t\t\"is_movie\": true\n"
                + "\t\t}\n"
                + "\t]\n"
                + "}";

        List<Episode> episodes = JsonDecoder.listFromJson(json);
        assertNotNull(episodes);
        assertEquals(2, episodes.size());

        Episode episode1 = episodes.get(0);
        assertEquals("Friendship is Magic Part 1", episode1.name);
        assertEquals(Instant.ofEpochSecond(1286735400), episode1.airDate);
        assertEquals(1, episode1.season);
        assertEquals(1, episode1.episode);
        assertEquals(false, episode1.isMovie);

        Episode episode2 = episodes.get(1);
        assertEquals("Equestria Girls", episode2.name);
        assertEquals(Instant.ofEpochSecond(1371340800), episode2.airDate);
        assertEquals(99, episode2.season);
        assertEquals(1, episode2.episode);
        assertEquals(true, episode2.isMovie);
    }
}
