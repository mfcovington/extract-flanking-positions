#!/usr/bin/env perl
# Mike Covington
# created: 2014-08-04
#
# Description:
#
use strict;
use warnings;
use autodie;
use feature 'say';
use Getopt::Long;
use Number::RangeTracker 0.6.0;

my ( $positions_file, $vcf_file, $flank_length );

my $options = GetOptions(
    "positions_file=s" => \$positions_file,
    "vcf_file=s"       => \$vcf_file,
    "flank_length=i"   => \$flank_length,
);

die unless defined $positions_file && defined $vcf_file && $flank_length > 0;

my %ranges;
open my $positions_fh, "<", $positions_file;
while (<$positions_fh>) {
    chomp;
    my ( $chr, $pos ) = split;
    $ranges{$chr} = Number::RangeTracker->new unless exists $ranges{$chr};
    $ranges{$chr}->add( $pos - $flank_length, $pos + $flank_length );
}
close $positions_fh;

open my $vcf_fh, "<", $vcf_file;
while (<$vcf_fh>) {
    next if /^#/;
    my ( $chr, $pos ) = split;
    say join "\t", $chr, $pos if $ranges{$chr}->is_in_range($pos);
}
close $vcf_fh;
