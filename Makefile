build:
	nim c -d:release --deadcodeElim:on --hints:off ponyapi

run: build
	./ponyapi
