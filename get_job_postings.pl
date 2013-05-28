#!/usr/bin/env perl

use v5.10;
use utf8;
use strict;
use warnings;

use File::Spec::Functions;
use Net::NNTP;

my $nntp = Net::NNTP->new('nntp.perl.org');
my( $count, $first, $last ) = $nntp->group( 'job_postings' );
say "$count, $first, $last";

my $dir = 'perl.companies';
mkdir $dir, 0755 unless -d $dir;

foreach my $i ( $first .. $last ) {
	my $file = catfile( $dir, "$i.txt" );
	next if -s $file;
	open my $fh, '>', $file;
	my $article = $nntp->article( $i, $fh );
	close $fh;
	say $i;
	sleep 1;
	}

$nntp->quit;
           
=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AVAILABILITY

=head1 AUTHOR

brian d foy C<< <brian.d.foy@gmail.com> >>

=head1 COPYRIGHT

Copyright 2012-2013, brian d foy C<< <brian.d.foy@gmail.com> >>

=cut




