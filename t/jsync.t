#!perl 

use Test::Tester;
use Test::JSYNC;
use Test::More tests => 36;

my $jsync = '[{"&":"1","..!":"foo","a":"*1"},["!!perl/array:Foo","*1",null]]';
my $good  = '[{"&":"1","..!":"foo","a":"*1"},["!!perl/array:Foo","*1",null]]';

my $desc = 'identical JSYNC should match';
check_test(
    sub { jsync_is $jsync, $good, $desc },
    {
        ok   => 1,
        name => $desc,
    },
    $desc
);

$good = '[{"&":"1","a":"*1","..!":"foo"},["!!perl/array:Foo","*1",null]]';
$desc = 'attribute order should not matter';
check_test(
    sub { jsync_is $jsync, $good, $desc },
    {
        ok   => 1,
        name => $desc,
    },
    $desc
);

# inalid type: perl/arry
my $invalid = '[{"&":"1","..!":"foo","a":"*1"},["!!perl/arry:Foo","*1",null]]';
$desc = 'Invalid jsync should fail';
check_test(
    sub { jsync_is $jsync, $invalid, $desc },
    {
        ok   => 0,
        name => $desc,
    },
    $desc
);

# "*2" should be "*1"
my $not_the_same = '[{"&":"1","..!":"foo","a":"*1"},["!!perl/array:Foo","*2",null]]';
$desc = 'Different JSYNC should fail';
check_test(
    sub { jsync_is $jsync, $not_the_same, $desc },
    {
        ok   => 0,
        name => $desc,
    },
    $desc
);

$jsync = '[{"&":"1","..!":"foo","a":"*1"},["!!perl/array:Foo","*1",null]]';
$desc  = 'Valid JSYNC should succeed';
check_test(
    sub { is_valid_jsync $jsync, $desc },
    {
        ok   => 1,
        name => $desc,
    },
    $desc
);

$invalid = '[{"&":"1","..!":"foo","a":"*1"},["!!perl/arry:Foo","*1",null]]';
$desc    = 'Invalid JSYNC should fail';
check_test(
    sub { is_valid_jsync $invalid, $desc },
    {
        ok   => 0,
        name => $desc,
    },
    $desc
);
