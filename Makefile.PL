# $Id: Makefile.PL,v 1.2 2004/09/15 11:35:43 eric Exp $

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Log::Dispatch::File::Stamped',
    AUTHOR        => 'Eric Cholet <cholet@logilune.com>',
    ABSTRACT      => 'logging to date/timestamped files',
    VERSION_FROM  => 'Stamped.pm',
    PM           => { 'Stamped.pm' => '$(INST_LIBDIR)/Stamped.pm' },
    PREREQ_PM    => {
                      Log::Dispatch       => 0,
                      Log::Dispatch::File => 0,
                      Test::More          => 0,
                    },
    dist         => { COMPRESS => 'gzip -9f',
                      SUFFIX   => 'gz',
                    },
);
