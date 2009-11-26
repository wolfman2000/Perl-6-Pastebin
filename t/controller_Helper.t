use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'P6Paste' }
BEGIN { use_ok 'P6Paste::Controller::Helper' }

ok( request('/helper')->is_success, 'Request should succeed' );


