# Package

version       = "0.2.0"
author        = "Cadey Dodrill"
description   = "PonyAPI server https://github.com/Xe/PonyAPI"
license       = "MIT"
bin           = @["ponyapi"]

# Dependencies

requires "nim >= 0.13.0", "jester#head", "random#head", "sam#head", "jsmn#head"
