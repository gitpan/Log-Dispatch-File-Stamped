
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Logging to date/time stamped files",
  "AUTHOR" => "Eric Cholet <cholet\@logilune.com>, Karen Etheridge <ether\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Log-Dispatch-File-Stamped",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Log::Dispatch::File::Stamped",
  "PREREQ_PM" => {
    "File::Basename" => 0,
    "File::Spec::Functions" => 0,
    "Log::Dispatch::File" => "2.38",
    "POSIX" => 0,
    "Params::Validate" => 0,
    "namespace::clean" => 0,
    "parent" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "FindBin" => 0,
    "Log::Dispatch" => 0,
    "Path::Tiny" => 0,
    "Test::CheckDeps" => "0.002",
    "Test::Deep" => 0,
    "Test::More" => "0.94",
    "Test::TempDir" => 0
  },
  "VERSION" => "0.12",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



