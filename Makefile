all: clean compile

compile:
	coffee -o lib -c src/ti-fighter.coffee

clean:
	rm -f lib/ti-fighter.js
