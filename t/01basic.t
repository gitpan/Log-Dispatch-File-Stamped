#!/usr/bin/perl
#
#$Id: 01basic.t,v 1.1 2003/02/08 13:30:30 eric Exp $

use strict;
use File::Spec::Functions qw(catfile);
use FindBin               qw($Bin);
use Test;

BEGIN { plan tests => 5 }

use Log::Dispatch;
use Log::Dispatch::File::Stamped;

my ($hour,$mday,$mon,$year) = (localtime)[2..5];
my @files;

my $dispatcher = Log::Dispatch->new;
ok($dispatcher);

my %params = (
    name      => 'file',
    min_level => 'debug',
    filename  => catfile($Bin, 'logfile.txt'),
);
my @tests = (
  { expected => sprintf("logfile-%04d%02d%02d.txt", $year+1900, $mon+1, $mday),
    params   => \%params,
  },
  { expected => sprintf("logfile-%02d%02d.txt", $mday, $hour),
    params   => { %params, stamp_fmt => '%d%H' },
  },
);
for my $t (@tests) {
    my $file = catfile($Bin, $t->{expected});
    push @files, $file;
    my $stamped = Log::Dispatch::File::Stamped->new(%{$t->{params}});
    ok($stamped);
    $dispatcher->add($stamped);
    $dispatcher->log( level   => 'info', message => 'Blah, blah' );
    ok(-e $file);
}
END {
    unlink @files if @files;
};
__END__
