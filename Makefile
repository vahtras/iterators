index.html: talk.md
	python refreeze/freeze.py

test:
	nosetests -vx --with-doctest --doctest-extension=md talk.md
