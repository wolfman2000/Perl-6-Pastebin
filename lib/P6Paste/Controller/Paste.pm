package P6Paste::Controller::Paste;

use utf8;
use strict;
use warnings;
use parent 'Catalyst::Controller';
use Digest::SHA qw(sha256_hex);
use DateTime;

=head1 NAME

P6Paste::Controller::Paste - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{name} = "Jason";

    $c->response->body('Matched P6Paste::Controller::Paste in Paste.');
}

sub submit :Local :Args(0) {
    my ( $self, $c ) = @_;

    unless (defined $c->request->params->{submit})
    {
        $c->stash->{template} = 'val_get.tt2';
        return;
    }
    
    my $cont = $c->request->params->{pCont};
    
    my $user = $c->request->params->{pNick};
    my $pass = $c->request->params->{pPass};
    my $subj = $c->request->params->{pSubj};
    my $dead = $c->request->params->{pDead}; # When does it expire (minutes)?
    my @tags = split(/ /, $c->request->params->{pTags});

    my @errors = ();

    my $tmp = $c->model('DBIC::Messages');
    my %attr = ('select' => ['message'], 'order_by' => 'RANDOM() LIMIT 1');
    my $mesN; # Message category number.

    unless (defined $cont and length $cont)
    {
        push @errors, "You have to provide some perl code!";
    }
    my $id;
    # Check username. If blank, assume anonymous.
    unless (defined $user and length $user) # No username provided
    {
        $user = "Anonymous";
        $id = 1;
        $mesN = 4;
    }
    elsif (defined $pass and length $pass) # If username and password provided
    {
        # Remember the password procedure: PW + p6 at the end, hashed.
        my %srch = (uname => $user, pword => sha256_hex($pass . "p6"));
        my %attr = ('select' => ['id'], );
        my $val = $c->model('DBIC::Users')->search(\%srch , \%attr );
        if ($val->count) # If a match:
        {
            $id = $val->first->id;
            $mesN = 5;
        }
        else
        {
            push @errors, "The username or password is incorrect.";
            $mesN = 3;
        }
    }
    else # Username, not password, provided
    {
        my %srch = (uname => $user, pword => undef );
        my %attr = ('select' => ['id'], );
        my $val = $c->model('DBIC::Users')->search(\%srch , \%attr )->single;
        $mesN = 4;
        if (defined $val) # There is a non registered user with this name: use it.
        {
            $id = $val->id;
        }
        else # New person entirely: add as unregistered.
        {
            my $now = DateTime->now();
            my %ins = (
                uname => $user,
                created => join(" ", split(/T/, $now)),
            );
            my $nu = $c->model('DBIC::Users')->create(\%ins);
            $id = $nu->id; # If I'm lucky, the ID was generated on insert.
        }
    }

    my %srch = ('me.cat_id' => $mesN);
    $c->stash->{funny} = $tmp->search(\%srch , \%attr )->first->message;

    if (scalar @errors)
    {
        $c->stash->{errors} = \@errors;
    }
    else
    {
#        use Data::Dumper; print Dumper $cont;
        my $now = DateTime->now;
        my $done;
        unless (defined $dead and length $dead)
        {
            $done = undef;
        }
        else
        {
            # Perl Map usage: map the time chosen.

            my @time;
            $time[30] = { minutes => 30 };
            $time[$_ * 60] = { hours => $_ } for 1,2,4,8,12;
            $time[$_ * 1440] = { days => $_ } for 1,2;
            $time[$_ * 10080] = { weeks => $_ } for 1,2;
            $time[$_ * 40320] = { months => $_ } for 1,2,6;
            $time[$_ * 483840] = { years => $_} for 1,100;

            $done = DateTime->now->add($time[$dead] ); 

        }
        my %ins = (
            user_id => $id,
            subject => $subj,
            content => $cont,
            tcheck => join(" ", split(/T/, $now)),
            expires => join(" ", split(/T/, $done)),
            ip => $c->request->address,
        );
        my $paste = $c->model('DBIC::Pastes')->create(\%ins );
        $c->stash->{pk} = $paste->id;
    }
    $c->stash->{template} = 'pasted.tt2';

}

=head1 AUTHOR

Jason Felds,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;