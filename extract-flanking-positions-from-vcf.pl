#!/usr/bin/env perl
# Mike Covington
# created: 2014-08-04
#
# Description:
#
use strict;
use warnings;
use Number::RangeTracker;
use autodie;
use feature 'say';

my $positions_file = "positions.txt";
my $vcf_file = "head.vcf";
my $flank_length = 150;

my %positions;

my %ranges;
open my $positions_fh, "<", $positions_file;
while (<$positions_fh>) {
    chomp;
    my ( $chr, $pos ) = split;
    $ranges{$chr} = RangeTracker->new unless exists $ranges{$chr};
    $ranges{$chr}->add_range( $pos - 150, $pos + 150 );
}
close $positions_fh;

open my $vcf_fh, "<", $vcf_file;
while (<$vcf_fh>) {
    next if /^#/;
    my ( $chr, $pos ) = split;
    say join "\t", $chr, $pos if $ranges{$chr}->is_in_range($pos);
}
close $vcf_fh;
