package P6Paste::Schema::ResultSet::Users;

use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

sub get_name
{
    my ($self, $uid) = @_;
    my $row = $self->find($uid, {select => ['uname']});
    return defined $row ? $row->uname : undef;
}

1;
