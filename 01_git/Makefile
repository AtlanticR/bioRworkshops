all: html pdf pres

html: git-cheat-sheet.html

pdf: git-cheat-sheet.pdf

pres: git-intro.pdf

git-cheat-sheet.html: git-cheat-sheet.md
	markdown $< > $@

git-cheat-sheet.pdf: git-cheat-sheet.md
	pandoc -V geometry:margin=1in $< -o $@

git-intro.pdf: git-intro.tex
	latexmk -pdf git-intro

clean:
	latexmk -c
	-rm -rf auto/
