package P6Paste::Schema::ResultSet::Pastes;

use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

sub get_valid_paste()
{
    my ($self, $pid) = @_; # Force array context.
    my %srch = ('me.id' => $pid, expires => [undef, {'>', => \q<datetime('now')> }]);
    my %attr = (join => 'users',
        select => [qw<me.subject me.content me.tcheck users.uname me.user_id users.pword>], );
    return $self->search(\%srch, \%attr)->first;
}

1;
