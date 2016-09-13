all: markdown csv

markdown: Perl_Companies.yaml
	./scripts/sql2md.pl

csv: Perl_Companies.yaml
	./scripts/sql2csv.pl
