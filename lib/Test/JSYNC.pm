package Test::JSYNC;

use strict;
use Carp;
use Test::Differences;
use JSYNC;

use base 'Test::Builder::Module';
our @EXPORT = qw/is_jsync is_valid_jsync/;

=head1 NAME

Test::JSYNC - Test JSYNC data

=head1 VERSION

This document describes Test::JSYNC version 0.01.

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

   use Test::JSYNC;

   is_valid_jsync $jsync,                  'jsync is well formed';
   is_jsync       $jsync, $expected_jsync, 'jsync matches what we expected';

=head1 DESCRIPTION

JSON YAML Notation Coding (JSYNC) is an extension of JSON that can serialize
any data objects.  Test::JSYNC makes it easy to verify that you have built
valid JSYNC and that it matches your expected output.

This module uses the L<JSYNC> module, which is currently the only CPAN module
to support JSYNC; however, the module itself states that it "is a very early
release of JSYNC, and should not be used at all unless you know what you are
doing."

=head1 EXPORTED TESTS

=head2 is_valid_jsync

Test passes if the string passed is valid JSYNC.

   is_valid_jsync $jsync, 'jsync is well formed';

=head2 is_jsync

Test passes if the two JSYNC strings are valid JSYNC and evaluate to the same
data structure.

   is_jsync $jsync, $expected_jsync, 'jsync matches what we expected';

L<Test::Differences> is used to provide easy diagnostics of why the JSYNC
structures did not match.  For example:

    #   Failed test 'jsync matches what we expected'
    #   in t/jsync.t at line 10.
    # +----+---------------------------+---------------------------+
    # | Elt|Got                        |Expected                   |
    # +----+---------------------------+---------------------------+
    # |   0|{                          |{                          |
    # |   1|  bool => '1',             |  bool => '1',             |
    # |   2|  description => bless( {  |  description => bless( {  |
    # |   3|    value => undef         |    value => undef         |
    # |   4|  }, 'Foo' ),              |  }, 'Foo' ),              |
    # |   5|  id => '1',               |  id => '1',               |
    # *   6|  name => 'foo'            |  name => 'fo'             *
    # |   7|}                          |}                          |
    # +----+---------------------------+---------------------------+

=cut

sub is_valid_jsync ($;$) {
    my ( $input, $test_name ) = @_;
    croak "usage: is_valid_jsync(input,test_name)"
      unless defined $input;
    eval { JSYNC::load($input) };
    my $test = __PACKAGE__->builder;
    if ( my $error = $@ ) {
        $test->ok( 0, $test_name );
        $test->diag("Input was not valid JSYNC:\n\n\t$error");
        return;
    }
    else {
        $test->ok( 1, $test_name );
        return 1;
    }
}

sub is_jsync ($$;$) {
    my ( $input, $expected, $test_name ) = @_;
    croak "usage: is_jsync(input,expected,test_name)"
      unless defined $input && defined $expected;

    my %jsync_for;
    foreach my $item ( [ input => $input ], [ expected => $expected ] ) {
        my $jsync = eval { JSYNC::load( $item->[1] ) };
        my $test = __PACKAGE__->builder;
        if ( my $error = $@ ) {
            $test->ok( 0, $test_name );
            $test->diag("$item->[0] was not valid JSYNC: $error");
            return;
        }
        else {
            $jsync_for{ $item->[0] } = $jsync;
        }
    }
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    eq_or_diff( $jsync_for{input}, $jsync_for{expected}, $test_name );
}

=head1 SEE ALSO

This module uses L<JSYNC> and L<Test::Differences>, and is based on
L<Test::JSON>.

=head1 AUTHORS

Nick Patch <patch@cpan.org>

Curtis "Ovid" Poe <ovid@cpan.org>

=head1 ACKNOWLEDGEMENTS

This module was forked from L<Test::JSON> by Curtis "Ovid" Poe.

=head1 COPYRIGHT & LICENSE

Copyright 2005-2007 Curtis "Ovid" Poe, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
