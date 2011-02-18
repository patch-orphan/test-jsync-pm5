#!perl 

use Test::Tester;
use Test::JSYNC;
use Test::More tests => 36;

my $jsync = '{"bool":1,"name":"foo","id":1,"description":null}';
my $good  = '{"bool":1,"name":"foo","id":1,"description":null}';

my $desc = 'identical JSYNC should match';
check_test(
    sub { is_jsync $jsync, $good, $desc },
    {
        ok   => 1,
        name => $desc,
    },
    $desc
);

$good = '{"bool":1,"id":1,"name":"foo","description":null}';
$desc = 'attribute order should not matter';
check_test(
    sub { is_jsync $jsync, $good, $desc },
    {
        ok   => 1,
        name => $desc,
    },
    $desc
);

# "null" is misspelled
my $invalid = '{"bool":1,"name":"fo","id":1,"description":nul}';
$desc = 'Invalid jsync should fail';
check_test(
    sub { is_jsync $jsync, $invalid, $desc },
    {
        ok   => 0,
        name => $desc,
    },
    $desc
);

# "fo" should be "foo"
my $not_the_same = '{"bool":1,"name":"fo","id":1,"description":null}';
$desc = 'Different JSYNC should fail';
check_test(
    sub { is_jsync $jsync, $not_the_same, $desc },
    {
        ok   => 0,
        name => $desc,
    },
    $desc
);

$jsync = '{"bool":1,"name":"fo","id":1,"description":null}';
$desc  = 'Valid JSYNC should succeed';
check_test(
    sub { is_valid_jsync $jsync, $desc },
    {
        ok   => 1,
        name => $desc,
    },
    $desc
);

$invalid = '{"bool":1,"name":"fo","id":1,"description":nul}';
$desc    = 'Invalid JSYNC should fail';
check_test(
    sub { is_valid_jsync $invalid, $desc },
    {
        ok   => 0,
        name => $desc,
    },
    $desc
);
