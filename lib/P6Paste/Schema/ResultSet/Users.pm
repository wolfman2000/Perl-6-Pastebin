package P6Paste::Schema::ResultSet::Users;

use strict;
use warnings;
use Digest::SHA qw(sha256_hex);
use DateTime;
use parent 'DBIx::Class::ResultSet';

sub is_name_taken # Returns an integer: 
{
    my ($self, $name) = @_;
    return $self->search({uname => $name, pword => {'!=' => undef} })->count;
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
