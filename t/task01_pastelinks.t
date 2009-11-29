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
    
    $schema->resultset('Pastes')->populate([ # Someone map the first 9 or something.
        {
            user_id => 1, subject => "Paste 1", content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ), ip => '1.2.3.4',
        },
        {
            user_id => 1, subject => "Paste 2", content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ), ip => '1.2.3.4',
        },
        {
            user_id => 1, subject => "Paste 3", content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ), ip => '1.2.3.4',
        },
        {
            user_id => 1, subject => "Paste 4", content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ), ip => '1.2.3.4',
        },
        {
            user_id => 1, subject => "Paste 5", content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ), ip => '1.2.3.4',
        },
        {
            user_id => 1, subject => "Paste 6", content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ), ip => '1.2.3.4',
        },
        {
            user_id => 1, subject => "Paste 7", content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ), ip => '1.2.3.4',
        },
        {
            user_id => 1, subject => "Paste 8", content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ), ip => '1.2.3.4',
        },
        {
            user_id => 1, subject => "Paste 9", content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ), ip => '1.2.3.4',
        },
        {
            user_id => 1, content => 'use v6; say "Hello World!";',
            tcheck => DateTime->new( year => 2009, month => 11, day => 1 ), ip => '1.2.3.4',
        },
    ]);
    
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'P6Paste');
    
    $mech->get_ok("/", "Get the entry page."); # Try to get the index page.
    is($mech->ct, "text/html", "Ensure the right content type is sent.");
    
    my $pastes = $schema->resultset('Pastes')->get_recent_pastes;
    
    my $counter = 1;
    while (my $row = $pastes->next)
    {
        my $subj = $row->subject // "No Subject";
        diag($row->id . "\n");
        $mech->follow_link_ok({text => $subj}, "Visit paste number $row->id");
        $mech->get_ok($mech->back, "Return back to the start after visiting paste $counter.");
        $counter++;
    }
};

done_testing;

