#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;

SKIP:
{
    skip 'Please set $ENV{MYAPP_DSN} to run this test.', 1 unless defined($ENV{MYAPP_DSN});
    BEGIN { use_ok 'Catalyst::Test', 'P6Paste' }
    
    ok( request('/')->is_success, 'Request should succeed' );
};

done_testing;
