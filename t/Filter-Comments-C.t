# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Filter-Comments-C.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 3;
BEGIN { use_ok('Filter::Comments::C') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $a = 0;
/*
$a++;
*/
ok( $a == 0, "C Comment" );

$a = 0;
#$a++;
#ok( $a == 0, "Perl Comment" );

SKIP: {
  skip "Not yet implemented in module", 1;
  $a = 0;
  #//$a++;
  ok( $a == 0, "C++ Comment" );
}
