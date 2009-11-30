#!perl
use strict;
use warnings;
use Test::More tests => 35;
use FindBin;
use DateTime;
use lib "$FindBin::Bin/../lib";


SKIP:
{
    skip 'Please set $ENV{MYAPP_DSN} to run this test.', 34 unless defined($ENV{MYAPP_DSN});
    BEGIN {use_ok 'P6Paste::Schema'};
    eval { require Test::WWW::Mechanize::Catalyst };

    skip 'Install Test::WWW::Mechanize::Catalyst for this test.', 34 if $@;
    
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
    
    # Don't supply a username.
    
    is($mech->submit_form(
        fields =>
        {
            regPass1 => 'thisworks',
            regPass2 => 'thisworks',
            regEmail => 'jafelds@gmail.com',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "A username must be supplied.");
    
    $mech->content_contains("You must provide a username to register.");
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");
    
    # Supply a name with characters generally not allowed on IRC.
    
        is($mech->submit_form(
        fields =>
        {
            regUser => '!@#$%^&*()',
            regPass1 => 'thisworks',
            regPass2 => 'thisworks',
            regEmail => 'jafelds@gmail.com',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "A username must be IRC validated.");
    
    $mech->content_contains("Your username contains illegal characters.");
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");
    
    # Usernames can't be taken if already in use.

    is($mech->submit_form(
        fields =>
        {
            regUser => 'Anonymous',
            regPass1 => 'thisworks',
            regPass2 => 'thisworks',
            regEmail => 'jafelds@gmail.com',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "A username must be unique.");
    
    $mech->content_contains("The requested username is not available.");
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");
    
    # Email addresses must be supplied to register.
    
    is($mech->submit_form(
        fields =>
        {
            regUser => 'PerlUser',
            regPass1 => 'thisworks',
            regPass2 => 'thisworks',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "The email address must be provided.");

    $mech->content_contains("You must provide an email address.");
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");
    
    # The email address has to be a valid one, of course.

    is($mech->submit_form(
        fields =>
        {
            regUser => 'PerlUser',
            regPass1 => 'thisworks',
            regPass2 => 'thisworks',
            regEmail => 'invalid.email.address',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "The email address must be valid.");
    
    $mech->content_contains("You must provide a valid email address.");
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");
    
    # Make sure this email address isn't taken either.

    is($mech->submit_form(
        fields =>
        {
            regUser => 'PerlUser',
            regPass1 => 'thisworks',
            regPass2 => 'thisworks',
            regEmail => 'jafelds@feather.perl6.nl',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "The email address must be unique.");
    
    $mech->content_contains("The requested email address is not available.");
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");
    
    # A password length has to be provided. (Check first field primarily)
    
    is($mech->submit_form(
        fields =>
        {
            regUser => 'PerlUser',
            regPass2 => 'thisworks',
            regEmail => 'jafelds@gmail.com',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "A password must be provided.");
    
    $mech->content_contains("You must provide a password to protect your account.");
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");
    
    # Of course, passwords must be secure. Keep it to 6 or more.
    
    is($mech->submit_form(
        fields =>
        {
            regUser => 'PerlUser',
            regPass1 => 'short',
            regPass2 => 'thisworks',
            regEmail => 'jafelds@gmail.com',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "A password must be a minimum length.");
    
    $mech->content_contains("Your password must be at least 6 characters.");
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");
    
    # In the end, the passwords have to match.
    
    is($mech->submit_form(
        fields =>
        {
            regUser => 'PerlUser',
            regPass1 => 'thisworks',
            regPass2 => 'thisdoesnot',
            regEmail => 'jafelds@gmail.com',
        },
        form_id => 'regForm',
        button => 'submit'
    )->code, 409, "A password must be matched with its other part..");
    
    $mech->content_contains("Your password and confirmation password must match.");
    $mech->follow_link_ok({text => "register"}, "Go to the registration page.");

    # Alright, let one piece of registration go already!

    $mech->submit_form_ok({
        fields =>
        {
            regUser => 'PerlUser',
            regPass1 => 'thisworks',
            regPass2 => 'thisworks',
            regEmail => 'jafelds@gmail.com',
        },
        form_id => 'regForm',
        button => 'submit'
    }, "Finally let the guy register!");
    
    $mech->content_contains("Success");

};

done_testing;

