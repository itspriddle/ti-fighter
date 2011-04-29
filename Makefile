all: clean compile

compile:
	coffee -b -o lib -c src/ti-fighter.coffee

clean:
	rm -f lib/ti-fighter.js
