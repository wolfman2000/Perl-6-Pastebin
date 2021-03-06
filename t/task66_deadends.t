#!perl
use strict;
use warnings;
use Test::More tests => 7;
use FindBin;
use DateTime;
use lib "$FindBin::Bin/../lib";


SKIP:
{
    skip 'Please set $ENV{MYAPP_DSN} to run this test.', 6 unless defined($ENV{MYAPP_DSN});
    BEGIN {use_ok 'P6Paste::Schema'};
    eval { require Test::WWW::Mechanize::Catalyst };

    skip 'Install Test::WWW::Mechanize::Catalyst for this test.', 6 if $@;
    
    my $schema = P6Paste::Schema->connect($ENV{MYAPP_DSN});
    
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'P6Paste');
    
    $mech->get_ok("/", "Get the entry page."); # Try to get the index page.
    is($mech->ct, "text/html", "Ensure the right content type is sent.");
    
    is($mech->get('/defnotarealpage')->code, 404, "Try to visit a fake page and get the results.");
    
    is($mech->get('/pview/notanumber')->code, 403, "Try to visit a real page with illegal parameters.");

    is($mech->get('/pview/99999')->code, 404, "Try to visit a real page, but with no paste.");

    is($mech->get('/register/validate')->code, 405, "Visits to the validation registration page must be by a form.");
};

done_testing;

