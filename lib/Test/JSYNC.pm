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

Version 0.01

=cut

our $VERSION = '0.11';

=head1 SYNOPSIS

 use Test::JSYNC;

 is_valid_jsync $jsync,                  '... jsync is well formed';
 is_jsync       $jsync, $expected_jsync, '... and it matches what we expected';

=head1 EXPORT

=over 4

=item * is_valid_jsync

=item * is_jsync

=back

=head1 DESCRIPTION

JSON YAML Notation Coding (JSYNC) is an extension of JSON that can serialize
any data objects.  L<Test::JSYNC> makes it easy to verify that you have built
valid JSYNC and that it matches your expected output.

See L<http://jsync.org/> for more information.

=head1 TESTS

=head2 is_valid_jsync

 is_valid_jsync $jsync, '... jsync is well formed';

Test passes if the string passed is valid JSYNC.

=head2 is_jsync

 is_jsync $jsync, $expected_jsync, '... and it matches what we expected';

Test passes if the two JSYNC strings are valid JSYNC and evaluate to the same
data structure.

L<Test::Differences> is used to provide easy diagnostics of why the JSYNC
structures did not match.  For example:

   Failed test '... and identical JSYNC should match'
   in t/10testjsync.t at line 14.
 +----+---------------------------+---------------------------+
 | Elt|Got                        |Expected                   |
 +----+---------------------------+---------------------------+
 |   0|{                          |{                          |
 |   1|  bool => '1',             |  bool => '1',             |
 |   2|  description => bless( {  |  description => bless( {  |
 |   3|    value => undef         |    value => undef         |
 |   4|  }, 'JSYNC::NotString' ), |  }, 'JSYNC::NotString' ), |
 |   5|  id => '1',               |  id => '1',               |
 *   6|  name => 'foo'            |  name => 'fo'             *
 |   7|}                          |}                          |
 +----+---------------------------+---------------------------+

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

=head1 AUTHOR

Curtis "Ovid" Poe, C<< <ovid@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests hrough the web interface at
L<https://github.com/patch/test-jsync-pm5/issues>.  I will be notified, and
then you'll automatically be notified of progress on your bug as I make
changes.

=head1 SEE ALSO

This test module uses L<JSYNC> and L<Test::Differences>.

=head1 ACKNOWLEDGEMENTS

The development of this module was sponsored by Kineticode,
L<http://www.kineticode.com/>, the leading provider of services for the
Bricolage content management system, L<http://www.bricolage.cc/>.

=head1 COPYRIGHT & LICENSE

Copyright 2005-2007 Curtis "Ovid" Poe, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
