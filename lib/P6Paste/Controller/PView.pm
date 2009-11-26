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

sub index :Path('/pview') :Args(1) { # Expecting the paste ID.
    my ( $self, $c, $pid ) = @_;
    
    # Get the paste subject, contents, date, expiration, username, userid, and reg check

    my %sql = ('me.id' => $pid, expires => [undef, {'>', => \q<datetime('now')> }] );
#    my $sql = "me.id = $pid AND ";
#    $sql .= q{(expires IS NULL OR datetime(tcheck, '+' || expires || ' minutes') > datetime('now'))};
    
    my %attr = (
        join => 'users',
        select => [ qw<me.subject me.content me.tcheck users.uname me.user_id users.pword> ]
    );
    
    my $row = $c->model('DBIC::Pastes')->search(\%sql, \%attr );
    
    unless (defined $row->first)
    {
        $c->stash->{expired} = 1;
    }
    else
    {
        $row = $row->first;

        my $txt = $row->content;
        $txt =~ s/\\\"/\"/g;
        eval
        {
        no warnings;
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
    $c->stash->{subject} = $row->subject // "No subject given.";
    $c->stash->{template} = 'pasteview.tt2';
}


=head1 AUTHOR

Jason Felds,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
