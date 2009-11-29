package P6Paste::Controller::Root;

use utf8;
use strict;
use warnings;
use HTTP::BrowserDetect;
use Data::Dumper;
use parent 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

P6Paste::Controller::Root - Root Controller for P6Paste

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 auto

Things that are loaded EVERY time.

=cut

sub auto :Private {
    my ($self, $c) = @_;
    
    # Get whether the browser is IE or not.
    $c->stash->{is_ie} //= HTTP::BrowserDetect->new->ie;

    # Get the name of the person. If the name isn't gotten, set later.
    $c->stash->{uname} = $c->model('DBIC::Users')->get_name($c->session->{id});

    # Retrieve the 10 recent pastes for the sidebar.
    $c->stash->{recentP} = $c->model('DBIC::Pastes')->get_recent_pastes;

}

=head2 index

The traditional index page.

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->stash->{template} = 'index.tt2';
}

=head2 default

The page called upon if nothing is found.

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    
    my $arg = $c->request->arguments->[0]; # Always defined here.
    if ($arg eq "pview")
    {
        $c->stash->{funny} = $c->model('DBIC::Messages')->get_rand_message(6);
        $c->stash->{template} = "pview_err.tt2";
    }
    else
    {
        $c->response->body( 'Page not found' );
    }
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Jason Felds,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
