#!perl
use strict;
use warnings;
use Test::More tests => 23;
use FindBin;
use DateTime;
use lib "$FindBin::Bin/../lib";


SKIP:
{
    skip 'Please set $ENV{MYAPP_DSN} to run this test.', 22 unless defined($ENV{MYAPP_DSN});
    BEGIN {use_ok 'P6Paste::Schema'};
    eval { require Test::WWW::Mechanize::Catalyst };

    skip 'Install Test::WWW::Mechanize::Catalyst for this test.', 22 if $@;
    
    my $schema = P6Paste::Schema->connect($ENV{MYAPP_DSN}); # Easy way to add pastes.
    
    $schema->resultset('Pastes')->populate([
        {
            user_id => 1, subject => "Paste $_", content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ),
        } foreach (1..9),
        {
            user_id => 1, content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ),
        },
    ]);
    
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'P6Paste');
    
    $mech->get_ok("/", "Get the entry page."); # Try to get the index page.
    is($mech->ct, "text/html", "Ensure the right content type is sent.");
    
    my $pastes = $schema->resultset('Pastes')->get_recent_pastes;
    
    while (my $row = $pastes->next)
    {
        my $subj = $row->subject // "No Subject";
        $mech->follow_link({text => $subj}, "Visit paste number $row->id");
        $mech->get_ok($mech->back, "Return back to the start.");
    }
};

done_testing;

