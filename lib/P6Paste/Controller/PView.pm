package P6Paste::Controller::PView;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use HTML::TreeBuilder;
use STD;
use Syntax::Highlight::Perl6;

=head1 NAME

P6Paste::Controller::PView - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

#sub index :Path('/pview') :Args(1) { # Expecting the paste ID.
sub index :Chained('/') :PathPart('pview') :Args(1) {
    my ( $self, $c, $pid ) = @_;
    
    unless ($pid == int $pid) # PID must be defined already.
    {
        $c->stash->{funny} = $c->model('DBIC::Messages')->get_rand_message(6);
        $c->stash->{template} = "pview_err.tt2";
        return;
    }
    
    # Get the paste data.
    my $row = $c->model('DBIC::Pastes')->get_valid_paste($pid);
    
    unless (defined $row)
    {
        $c->stash->{expired} = 1;
    }
    else
    {
        $c->stash->{subject} = $row->subject // "No subject given.";
        my $txt = $row->content;
        $txt =~ s/\\\"/\"/g;
        no warnings;
        eval
        {
        my $DEBUG = 0; # Placeholder
        my $perl = Syntax::Highlight::Perl6->new( text => $txt );
        my $out = $perl->simple_html;
        my $html = HTML::TreeBuilder->new_from_content($out);
        my $last = $html->look_down("_tag" => "pre")->as_HTML();
        $c->stash->{pastview} = $last;
        $html->delete(); # Free the memory as soon as possible.
        };
        if ($@)
        {
            $c->stash->{pastview} = "<pre>$txt</pre>";
        }
    }
    $c->stash->{template} = 'pasteview.tt2';
}


=head1 AUTHOR

Jason Felds,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
