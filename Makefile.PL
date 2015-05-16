use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'DBIx::HTML',
    AUTHOR           => q{Jeff Anderson <jeffa@cpan.org>},
    VERSION_FROM     => 'lib/DBIx/HTML.pm',
    ABSTRACT_FROM    => 'lib/DBIx/HTML.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Spreadsheet::HTML' => '0.04',
        'DBIx::XHTML_Table' => '1.39',
    },
    PREREQ_PM => { },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'DBIx-HTML-*' },
);
