#!perl
use strict;
use warnings;
use Test::More tests => 1;


SKIP:
{
    skip 'Please set $ENV{MYAPP_DSN} to run this test.', 1 unless defined($ENV{MYAPP_DSN});
    my @parts = split/\:/, $ENV{MYAPP_DSN};
    cmp_ok(unlink($parts[2]), '==', 1, 'Remove the test database that was used.');
};
