#!/usr/bin/perl
#
#$Id: pod.t,v 1.1 2004/09/15 11:55:26 eric Exp $

use strict;
use File::Find;
use Test::More;

my @files;
find( sub { push @files, $File::Find::name if /\.p(?:m|od)$/ }, '.' );

plan tests => scalar @files;

SKIP: {
    eval { require Test::Pod; import Test::Pod; };
    skip "Test::Pod not available", scalar @files if $@;
    if ( $Test::Pod::VERSION >= 0.95 ) {
        pod_file_ok($_) for @files;
    }
    else {
        pod_ok($_) for @files;
    }
}

