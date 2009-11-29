use strict;
use warnings;
use Test::More tests => 3;

SKIP:
{
skip 'Plese set $ENV{MYAPP_DSN} to run these tests.', 1 unless defined($ENV{MYAPP_DSN});
BEGIN { use_ok 'Catalyst::Test', 'P6Paste' }
BEGIN { use_ok 'P6Paste::Controller::PView' }

ok( request('/pview')->is_error, 'Request should fail: no paste id.' );
};

