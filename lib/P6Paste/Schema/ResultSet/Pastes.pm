package P6Paste::Schema::ResultSet::Pastes;

use strict;
use warnings;
use DateTime;
use parent 'DBIx::Class::ResultSet';

sub add_paste() # Return the new paste ID.
{
    my ($self, $uid, $subject, $content, $dead, $ip) = @_;
    my $done;
    my $now = DateTime->now;
    if (defined $dead and length $dead)
    {
        # Perl map usage here: map the time chosen.
        my @time;
        $time[30] = { minutes => 30 };
        $time[$_ * 60] = { hours => $_ } for 1,2,4,8,12;
        $time[$_ * 1440] = { days => $_ } for 1,2;
        $time[$_ * 10080] = { weeks => $_ } for 1,2;
        $time[$_ * 40320] = { months => $_ } for 1,2,6;
        $time[$_ * 483840] = { years => $_} for 1,100;

        $done = DateTime->now->add($time[$dead] );
    }
    my $ins = {
        user_id => $uid,
        subject => $subject,
        content => $content,
        tcheck => join(" ", split(/T/, $now)),
        expires => defined $done ? join(" ", split(/T/, $done)) : undef,
        ip => $ip,
    };
    return $self->create($ins)->id;
}

sub get_valid_paste()
{
    my ($self, $pid) = @_; # Force array context.
    my %srch = ('me.id' => $pid, expires => [undef, {'>', => \q<datetime('now')> }]);
    my %attr = (join => 'users',
        select => [qw<me.subject me.content me.tcheck users.uname me.user_id users.pword>], );
    return $self->search(\%srch, \%attr)->first;
}

sub get_recent_pastes()
{
    my $self = shift;
    my $srch = {expires => [undef, {'>', => \q<datetime('now')> }] };
    my $attr = { prefetch => 'users', order_by => 'tcheck DESC LIMIT 10' };
    return $self->search($srch, $attr);
}

1;
