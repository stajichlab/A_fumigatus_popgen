#!env perl
use strict;
use warnings;
my %l;
my @lookup = qw(info/DRP001352.txt info/DRP002354.txt);
for my $lookup ( @lookup ) {
    open(my $fh => $lookup) || die $!;

    my $header = <$fh>;
    while(<$fh>) {
	my ($strain,$biosamp,$sra) = split(/\t/,$_);
	$strain =~ s/\s+/_/g;
	$l{$biosamp} = $strain;
	$l{$sra} = $strain;
    }
}

open(my $sra_table => 'sra_strains.tab' ) || die $!;
while(<$sra_table>) {
    my (@row) = split(/\t/,$_);
    
    if( exists $l{$row[2]} ) {
	warn("found $l{$row[2]} for $row[2]\n");
	$row[2] = $l{$row[2]};
    }
    print join("\t",@row);
}
