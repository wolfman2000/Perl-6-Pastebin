package P6Paste::Schema::ResultSet::Users;

use strict;
use warnings;
use Digest::SHA qw(sha256_hex);
use DateTime;
use parent 'DBIx::Class::ResultSet';

sub is_name_taken # Returns an integer 
{
    my ($self, $name) = @_;
    return $self->search({uname => $name, pword => {'!=' => undef} })->count;
}

sub is_email_taken # Returns an integer
{
    my ($self, $email) = @_;
    return $self->search({'email' => $email})->count();
}

sub get_name
{
    my ($self, $uid) = @_;
    my $row = $self->find($uid, {select => ['uname']});
    return defined $row ? $row->uname : undef;
}

sub get_id_row # Relies on username and "optional" password.
{
    my ($self, $name, $pass) = @_;
    my $srch = {uname => $name,
        pword => defined $pass ? sha256_hex($pass . "p6") : undef};
    my $attr = {select => ['id'], };
    return $self->search($srch, $attr);
}

sub add_registered # Just return a true value.
{
    my ($self, $name, $pass, $email) = @_;
    if (not $self->is_name_taken($name))
    {
        # Force other posts to orphaned: have a clean slate.
        $self->update({user_id => 2})->where({uname => $name});
    }
    my $ins = {
        uname => $name,
        pword => sha256_hex($pass . "p6"),
        email => $email,
        created => join(" ", split(/T/, DateTime->now)),
    };
    $self->create($ins);
    return 1;
}

sub add_unregistered # Return the ID: that will almost always be used.
{
    my ($self, $user) = @_;
    my $ins = {
        uname => $user,
        created => join(" ", split(/T/, DateTime->now)),
    };
    return $self->create($ins)->id;
}

1;

__END__

=head1 DESCRIPTION

This ResultSet expands upon the default Users ResultSet.

=head1 METHODS

=head2 is_name_taken

Returns a true value if the name supplied is taken by a registered user.

=head2 is_email_taken

Returns a true value if the email supplied is taken by a registered user.

=head2 get_name

Retrieves the name of the person based upon the user ID, if supplied.
Returns undef if the user ID was not supplied properly.

=head2 get_id_row

Retrieves the row containing the ID of the person.
It requires the username and optionally the password to check if
the nick is registered.

=head2 add_registered

Adds a new registered user with a username, password, and email.

=head2 add_unregistered

Adds a new unregistered user with a username. Returns the ID
created by it so it can immediately be used for linking to a paste.

=head1 SEE ALSO

=head2 L<Catalyst> - The Catalyst framework
  
=head2 L<DBIx::Class> - The DBIC framework

=head2 L<P6Paste::Schema::Result::Users> - The Users Table

=head1 AUTHOR

Jason Felds

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
