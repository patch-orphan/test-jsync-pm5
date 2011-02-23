#!perl 

use Test::Tester;
use Test::JSYNC;
use Test::More tests => 36;

my $json = '{"bool":1,"name":"foo","id":1,"description":null}';
my $good = '{"bool":1,"name":"foo","id":1,"description":null}';

my $desc = 'identical JSON should match';
check_test(
    sub { jsync_is $json, $good, $desc },
    {
        ok   => 1,
        name => $desc,
    },
    $desc
);

$good = '{"bool":1,"id":1,"name":"foo","description":null}';
$desc = 'attribute order should not matter';
check_test(
    sub { jsync_is $json, $good, $desc },
    {
        ok   => 1,
        name => $desc,
    },
    $desc
);

# "null" is misspelled
my $invalid = '{"bool":1,"name":"fo","id":1,"description":nul}';
$desc = 'Invalid json should fail';
check_test(
    sub { jsync_is $json, $invalid, $desc },
    {
        ok   => 0,
        name => $desc,
    },
    $desc
);

# "fo" should be "foo"
my $not_the_same = '{"bool":1,"name":"fo","id":1,"description":null}';
$desc = 'Different JSON should fail';
check_test(
    sub { jsync_is $json, $not_the_same, $desc },
    {
        ok   => 0,
        name => $desc,
    },
    $desc
);

$json = '{"bool":1,"name":"fo","id":1,"description":null}';
$desc = 'Valid JSON should succeed';
check_test(
    sub { is_valid_jsync $json, $desc },
    {
        ok   => 1,
        name => $desc,
    },
    $desc
);

$invalid = '{"bool":1,"name":"fo","id":1,"description":nul}';
$desc    = 'Invalid JSON should fail';
check_test(
    sub { is_valid_jsync $invalid, $desc },
    {
        ok   => 0,
        name => $desc,
    },
    $desc
);
