use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'P6Paste' }
BEGIN { use_ok 'P6Paste::Controller::PView' }

ok( request('/pview')->is_error, 'Request should fail: no paste id.' );


