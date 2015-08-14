build:
	nim c --deadcodeElim:on --hints:off ponyapi

run: build
	./ponyapi
