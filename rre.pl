##################################
#
#rre.pl
#
#redo regression: eliminate _ from non-include tests
#

use strict;
use warnings;

my %include;

open(A, $ARGV[0]) || die ("Can't open file $ARGV[0]");

while (my $l = <A>)
{
  if ($l =~ />\{include\}/)
  {
    my $k = $l; chomp($k);
    $k =~ s/.*include\} *//g;
    $include{$k} = 1;
  }
}

close(A);

open(A, $ARGV[0]) || die ("Can't re-open file $ARGV[0]");
open(B, ">reg-temp.txt");

while (my $l = <A>)
{
  if ($l !~ /^\* ?_/) { print B $l; next; }
  my $k = $l; chomp($k); $k =~ s/^\* *//g;
  if ($k =~ /^_/) { if ($include{$k}) { print "Ignoring $k.\n"; print B $l; next; } }
  print "Removing underline from $l";
  $l =~ s/^\* *_/\* /g;
  print B $l;
}

close(B);