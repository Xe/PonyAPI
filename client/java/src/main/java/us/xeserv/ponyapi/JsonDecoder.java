package us.xeserv.ponyapi;

import com.google.common.base.Strings;
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
        if (Strings.isNullOrEmpty(json)) {
            return null;
        }
        try {
            JsonObject wrapper = (JsonObject) new JsonParser().parse(json);
            JsonObject payload = wrapper.get("episode").getAsJsonObject();
            return gson.fromJson(payload, Episode.class);
        } catch (Exception ignored) {
            // TODO: Logging for parse errors or passing a general parse exception
        }
        return null;
    }

    protected static List<Episode> listFromJson(String json) {
        if (Strings.isNullOrEmpty(json)) {
            return null;
        }
        List<Episode> list = new ArrayList<>();
        try {
            JsonObject wrapper = (JsonObject) new JsonParser().parse(json);
            JsonArray payload = wrapper.get("episodes").getAsJsonArray();
            for (JsonElement episode : payload) {
                list.add(gson.fromJson(episode, Episode.class));
            }
        } catch (Exception ignored) {
            // TODO: Logging for parse errors or passing a general parse exception
        }
        if (list.isEmpty()) {
            return null;
        }
        return list;
    }

}
