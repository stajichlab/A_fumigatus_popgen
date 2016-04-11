#!env perl
use strict;
use Bio::SeqIO;

# rewrite me someday
my $gff = shift || die "need gff";
my $db = shift || die "need genome db";
my $report = shift || die "need FASTA report";

my %loc;
open(my $gffh => $gff) || die $!;
while(<$gffh>) {
    next if /^\#/;
    chomp;
    my @row = split(/\t/,$_);
    next unless $row[2] eq 'gene' || $row[2] eq 'pseudogene';
    my %grp = map { split(/=/, $_) } split(/;/,pop @row);
    my $id = $grp{ID};
#    warn("id is $id\n");
    $loc{$id} = [ $row[0], $row[3],$row[4],$row[6]];
}
my %names;
my $in = Bio::SeqIO->new(-format => 'fasta', -file => $db);
while( my $s = $in->next_seq ) {
    $names{$s->display_id} = $s->length;
}
open(my $fh => $report) || die $!;
my %seen;
while(<$fh>) {
    next if /^\#/;
    chomp;
    my @row = split(/\t/,$_);
    my ($q,$h,$pid,$alnlen) = @row;
    if( $seen{$q} ) { # save only best hit for now
	next;
    }
    $seen{$q} = [$h, $pid, $alnlen];
}
my $oname = $report;
$oname =~ s/\.FASTA$//;
open(my $hits => ">$oname.hits.dat") || die $!;
open(my $miss => ">$oname.missing.dat") || die $!;
my %expected = %names;
print $hits join(",",qw(QUERY HIT PID ALNLEN CHROM START STOP STRAND)), "\n";
for my $qseq ( sort keys %seen ) {
    print $hits join(",",$qseq,@{$seen{$qseq}}, @{$loc{$qseq}}), "\n";
    delete $expected{$qseq};
}
print $miss join(",",qw(QNAME LENGTH CHROM START STOP STRAND)), "\n";
for my $n ( sort keys %expected) {
    if( ! exists $loc{$n} ) {
	warn("no info for $n in gff file\n");
    }
    print $miss join(",",$n,$expected{$n}, @{$loc{$n} || []} ),"\n";
}
