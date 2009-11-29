#!perl
use strict;
use warnings;
use Test::More tests => 10;
use FindBin;
use DateTime;
use lib "$FindBin::Bin/../lib";


SKIP:
{
    skip 'Please set $ENV{MYAPP_DSN} to run this test.', 9 unless defined($ENV{MYAPP_DSN});
    BEGIN {use_ok 'P6Paste::Schema'};
    eval { require Test::WWW::Mechanize::Catalyst };

    skip 'Install Test::WWW::Mechanize::Catalyst for this test.', 9 if $@;
    
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
    
    $mech->submit_form_ok(
        {
            fields =>
            {
                pCont => 'use v6;' . chr(13) . chr(10) . 'say (1..6).pick;',
                pNick => 'NonRegisteredTester',
            },
            form_id => 'pasteForm',
            button => 'submit',
        },
        "Have a non registered user submit a paste."
    );
    $mech->follow_link_ok({text => "here"}, "Go to your recent paste.");
    $mech->follow_link_ok({text => "Perl 6 Pastebin"}, "Go to the entry page.");
    
    # Try to submit without anything: should fail.

    is($mech->submit_form(
        fields =>
        {
            pNick => 'NonRegisteredTester',
        },
        form_id => 'pasteForm',
        button => 'submit'
    )->code, 409, "Submitting a page with no content should fail.");

    
};

done_testing;

