use strict;
use warnings;

# remove indel Alleles

while(<>) {
    if( /^#/ ) { 
	print; 
	next; 
    }
    
    my @row = split(/\t/,$_);
    if( length($row[4]) > 1 || length($row[3]) > 1 ) {
#	warn("$row[4]\n");
    } else {
	print;
    }
}
