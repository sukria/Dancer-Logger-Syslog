use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Dancer::Logger::Syslog',
    AUTHOR              => q{Alexis Sukrieh <sukria@sukria.net>},
    VERSION_FROM        => 'lib/Dancer/Logger/Syslog.pm',
    ABSTRACT            => 'Dancer logger engine for Sys::Syslog',
    'LICENSE'           => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'  => 0,
        'Dancer'      => 1.123,
        'Sys::Syslog' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Dancer-Logger-Syslog-*' },
);
