#!perl
use strict;
use warnings;
use Test::More tests => 1;


SKIP:
{
    skip 'Please set $ENV{MYAPP_DSN} to run this test.', 1 unless defined($ENV{MYAPP_DSN});
    
    cmp_ok (unlink $ENV{MYAPP_DSN}, '==', 1, 'Remove the test database that was used.');
};
