package P6Paste::Schema::ResultSet::Users;

use strict;
use warnings;
use Digest::SHA qw(sha256_hex);
use parent 'DBIx::Class::ResultSet';

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

1;
