package us.xeserv.ponyapi;

import com.google.gson.*;

import java.util.ArrayList;
import java.util.List;

class JsonDecoder {

    private static final Gson gson;
    static {
        GsonBuilder gsonBuilder = new GsonBuilder();
        gsonBuilder.registerTypeAdapter(Episode.class, (JsonDeserializer<Episode>) (json, typeOfT, context) -> {
            JsonObject jsonObject = json.getAsJsonObject();
            return new Episode(
                    jsonObject.get("name").getAsString(),
                    jsonObject.get("season").getAsInt(),
                    jsonObject.get("episode").getAsInt(),
                    jsonObject.get("air_date").getAsLong(),
                    jsonObject.get("is_movie").getAsBoolean()
            );
        });
        gson = gsonBuilder.create();
    }

    protected static Episode fromJson(String json) {
        JsonObject wrapper = (JsonObject) new JsonParser().parse(json);
        JsonObject payload = wrapper.get("episode").getAsJsonObject();
        return gson.fromJson(payload, Episode.class);
    }

    protected static List<Episode> listFromJson(String json) {
        List<Episode> list = new ArrayList<>();
        JsonObject wrapper = (JsonObject) new JsonParser().parse(json);
        JsonArray payload = wrapper.get("episodes").getAsJsonArray();
        for (JsonElement episode : payload) {
            list.add(gson.fromJson(episode, Episode.class));
        }
        return list;
    }

}
