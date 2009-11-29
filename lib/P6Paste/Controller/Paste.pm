package P6Paste::Controller::Paste;

use utf8;
use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

P6Paste::Controller::Paste - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

Shortcut to paste submission.

=cut

sub index :Path :Args(0) {
    my ($self, $c) = @_;
    return $self->submit($c);
}

=head2 submit

Upload paste submissions.

=cut

sub submit :Local :Args(0) {
    my ( $self, $c ) = @_;

    unless (defined $c->request->params->{submit})
    {
        $c->stash->{template} = 'val_get.tt2';
        $c->response->status(403); # Must come in through post.
        return;
    }
    
    my $cont = $c->request->params->{pCont};
    
    my $user = $c->request->params->{pNick};
    my $pass = $c->request->params->{pPass};
    my $subj = $c->request->params->{pSubj};
    my $dead = $c->request->params->{pDead}; # When does it expire (minutes)?
    my @tags = split(/ /, $c->request->params->{pTags});

    my @errors = ();

    my $mesN; # Message category number.

    unless (length $cont)
    {
        push @errors, "You have to provide some perl code!";
    }
    my $id;
    # Check username. If blank, assume anonymous.
    unless (length $user) # No username provided
    {
        $user = "Anonymous";
        $id = 1;
        $mesN = 4;
    }
    elsif (length $pass) # If username and password provided
    {
        my $val = $c->model('DBIC::Users')->get_id_row($user, $pass);
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
        my $val = $c->model('DBIC::Users')->get_id_row($user)->single;
        $mesN = 4;
        if (defined $val) # There is a non registered user with this name: use it.
        {
            $id = $val->id;
        }
        else # New person entirely: add as unregistered.
        {
            $id = $c->model('DBIC::Users')->add_unregistered($user);            
        }
    }

    $c->stash->{funny} = $c->model('DBIC::Messages')->get_rand_message($mesN);

    if (scalar @errors)
    {
        $c->stash->{errors} = \@errors;
        $c->response->status(409);
    }
    else
    {
        $c->stash->{pk} = $c->model('DBIC::Pastes')->add_paste($id, $subj, $cont, $dead, $c->request->address);
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
