use strict;
use warnings;
use utf8;
use Test::More;

eval 'use Test::Pod::Coverage 1.00';
plan skip_all => 'Test::Pod::Coverage 1.00 not installed; skipping' if $@;

all_pod_coverage_ok({ trustme => [qw( is_valid_jsync is_jsync )] });
