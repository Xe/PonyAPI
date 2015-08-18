package us.xeserv.ponyapi;

import java.time.Instant;
import java.util.Objects;

/**
 * The {@code Episode} class represents My Little Pony episode or movie information returned by PonyAPI.
 * <p>
 * Episodes are immutable; they represent data returned from the API and cannot be changed after they are created.
 * <p>
 * Movie data stored in an {@code Episode} object are referred to by the season number 99. Their episode number refers
 * to the order of their release starting with 1.
 *
 * @author Justin Kaufman
 * @since 1.0
 */
public class Episode {

    /**
     * The name of the episode or movie.
     */
    public final String name;

    /**
     * The season of the episode, or 99 if it is a movie.
     */
    public final int season;

    /**
     * The episode or movie number.
     */
    public final int episode;

    /**
     * The air date.
     */
    public final Instant airDate;

    /**
     * True if this episode represents a movie, false otherwise.
     */
    public final boolean isMovie;

    protected Episode(String name, int season, int episode, long airDate, boolean isMovie) {
        this.name = name;
        this.season = season;
        this.episode = episode;
        this.airDate = Instant.ofEpochSecond(airDate);
        this.isMovie = isMovie;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Episode rhs = (Episode) obj;
        return Objects.equals(name, rhs.name)
                && Objects.equals(season, rhs.season)
                && Objects.equals(episode, rhs.episode)
                && Objects.equals(airDate, rhs.airDate)
                && Objects.equals(isMovie, rhs.isMovie);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, season, episode, airDate, isMovie);
    }

    @Override
    public String toString() {
        return "{\n"
                + "\t\"name\": \"" + name + "\",\n"
                + "\t\"air_date\": " + airDate.getEpochSecond() + ",\n"
                + "\t\"season\": " + season + ",\n"
                + "\t\"episode\": " + episode + ",\n"
                + "\t\"is_movie\": " + isMovie + "\n"
                + "}";
    }

}