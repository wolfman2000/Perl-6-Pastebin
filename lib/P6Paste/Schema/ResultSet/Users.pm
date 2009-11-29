package P6Paste::Schema::ResultSet::Users;

use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

sub get_name
{
    my ($self, $uid) = @_;
    return $self->find($uid, {select => ['uname']})->uname;
}

1;
