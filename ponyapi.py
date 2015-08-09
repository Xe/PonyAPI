import os
import random
from flask import Flask, abort, jsonify

# An Episode is constructed as such:
# data Episode = Episode
#               { name     :: String
#               , air_date :: Int
#               , season   :: Int
#               , episode  :: Int
#               , is_movie :: Bool
#               }
#
# Any instance of season 99 should be interpreted as a movie.
episodes = []

# First, open the input file and read in episodes
with open("./fim.list", "r") as f:
    for line in f:
        airdate, s, e, name = line.split(' ', 4)[1:]

        episode = {
            "name": name[:-1],
            "air_date": int(airdate),
            "season": int(s),
            "episode": int(e),
            "is_movie": s == "99"
        }

        episodes.append(episode)

# Now, initialize Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Welcome to the Pony API!"

@app.route("/all")
def all_episodes():
    return jsonify(episodes=episodes)

@app.route("/season/<number>")
def season(number):
    retEpisodes = []

    for episode in episodes:
        if str(episode["season"]) == number:
            retEpisodes.append(episode)

    try:
        assert len(retEpisodes) > 0
    except:
        abort(404)

    return jsonify(episodes=retEpisodes)

@app.route("/random")
def show_random_ep():
    return jsonify(episode=random.choice(episodes))

@app.route("/search")
def search():
    abort(500)

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
