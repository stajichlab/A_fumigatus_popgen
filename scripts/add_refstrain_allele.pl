#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;

my $file = shift || "Afum.A1163.selected_noindel.tab";
my $id = shift || "A1163";

open(my $fh => $file ) || die "cannot open $file: $!";
my $ref_allele;
my $header = <$fh>;
while(<$fh>) {
    chomp;
    my ($chrom,$pos,$ref) = split(/\t/,$_);
    $ref = '-' if $ref eq '.';
    $ref_allele .= $ref;
}

my $out = Bio::SeqIO->new(-format => 'fasta');
$out->write_seq(Bio::Seq->new(-id  => $id,
			      -seq => $ref_allele));
