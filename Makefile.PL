# $Id: Makefile.PL,v 1.1 2003/02/08 13:30:30 eric Exp $

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
                    },
    dist         => { COMPRESS => 'gzip -9f',
                      SUFFIX   => 'gz',
                    },
);
