use 5.008008;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Filter::Comments::C',
    VERSION_FROM      => 'lib/Filter/Comments/C.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Filter/Comments/C.pm', # retrieve abstract from module
       AUTHOR         => 'Matthew J. Kosmoski <kosmo@cpan.org>') : ()),
);
