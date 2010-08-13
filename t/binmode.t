#!/usr/bin/perl

use strict;
use File::Spec::Functions qw(catfile);
use FindBin               qw($Bin);
use Test::More tests => 7;

use_ok('Log::Dispatch');
use_ok('Log::Dispatch::File::Stamped');

my ($hour,$mday,$mon,$year) = (localtime)[2..5];
my @files;

my %params = (
    name      => 'file',
    min_level => 'debug',
    filename  => catfile($Bin, 'logfile.txt'),
);
my @tests = (
  { expected => sprintf("logfile-%04d%02d%02d.txt", $year+1900, $mon+1, $mday),
    params   => {%params, 'binmode' => ':encoding(cp932)'},
    message  => "foo bar\x{307b}",
    expected_message => "foo bar\x82\xd9",
  },
);
for my $t (@tests) {
    my $dispatcher = Log::Dispatch->new;
    ok($dispatcher);
    my $file = catfile($Bin, $t->{expected});
    push @files, $file;
    my $stamped = Log::Dispatch::File::Stamped->new(%{$t->{params}});
    ok($stamped);
    $dispatcher->add($stamped);
    $dispatcher->log( level   => 'info', message => $t->{message} );
    ok(-e $file);
    open my $fh, "<$file";
    ok($fh);
    local $/ = undef;
    my $line = <$fh>;
    close $fh;
    is($line, $t->{expected_message}, 'output');
}
END {
    unlink @files if @files;
};
__END__
