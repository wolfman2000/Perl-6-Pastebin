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
    
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");
    
    # Try invalid combinations first.
    
    is($mech->submit_form(
        fields =>
        {
            
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "Registering with no anything should fail.");
    
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");    
    
    is($mech->submit_form(
        fields =>
        {
            regUser => 'PerlUser',
            regPass1 => 'sml',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "The password can't be too short.");

    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");
    
    is($mech->submit_form(
        fields =>
        {
            regUser => 'PerlUser',
            regPass1 => 'matching',
            regPass2 => 'matching',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "The email must be properly formed.");

    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");

    
};

done_testing;

