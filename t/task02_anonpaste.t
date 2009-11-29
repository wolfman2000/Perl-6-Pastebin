#!perl
use strict;
use warnings;
use Test::More tests => 6;
use FindBin;
use DateTime;
use lib "$FindBin::Bin/../lib";


SKIP:
{
    skip 'Please set $ENV{MYAPP_DSN} to run this test.', 5 unless defined($ENV{MYAPP_DSN});
    BEGIN {use_ok 'P6Paste::Schema'};
    eval { require Test::WWW::Mechanize::Catalyst };

    skip 'Install Test::WWW::Mechanize::Catalyst for this test.', 5 if $@;
    
    my $schema = P6Paste::Schema->connect($ENV{MYAPP_DSN});
    
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'P6Paste');
    
    $mech->get_ok("/", "Get the entry page."); # Try to get the index page.
    is($mech->ct, "text/html", "Ensure the right content type is sent.");
    
    $mech->submit_form_ok(
        {
            fields =>
            {
                pCont => 'use v6;' . chr(13) . chr(10) . 'say "Hello World!";',
            },
            form_id => 'pasteForm',
            button => 'submit',
        },
        "Have an anonymous user submit a paste."
    );
    $mech->follow_link_ok({text => "here"}, "Go to your recent paste.");
    $mech->follow_link_ok({text => "Perl 6 Pastebin"}, "Go to the entry page.");
    
    # Now put in a name for this user.
};

done_testing;

