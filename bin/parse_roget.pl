#!/usr/bin/perl

use strict;
use warnings;

use Parse::GutenbergRoget;

my $roget_filename = ($ARGV[0] || 'roget15a.txt');

my %section = parse_roget($roget_filename);

for (
	sort { ($a->{major} <=> $b->{major}) || ($a->{minor} cmp $b->{minor}) }
	values %section
) {
	print "$_->{major}", $_->{minor}||'', ": $_->{name}";
	print " (", join(', ',@{$_->{comments}}), ")" if
		@{$_->{comments}};
	print "\n";

	for my $subsection (@{$_->{subsections}}) {
		print " * ($subsection->{type})\n";

		for my $group (@{$subsection->{groups}}) {
			print "  *\n";

			for (@{$group->{entries}}) {
				print "   * $_->{text}\n"
			}
		}
	}
}
