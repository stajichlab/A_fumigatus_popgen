my ($one,$two) = @ARGV;

my %l;
open(my $fh => $one ) || die $!;

while(<$fh>) {
    my @row = split(/\t/,$_);
    $l{$row[2]} = $row[1];
}

open($fh => $two) || die $!;
my $header =<$fh>;
my @h = split(/\t/,$header);
splice(@h,1,0,qw(SRARUN));
print join("\t",@h);
while(<$fh>) {
    my @row = split(/\t/,$_);
    splice(@row,1,0,$l{$row[1]});
    print join("\t",@row);
}
