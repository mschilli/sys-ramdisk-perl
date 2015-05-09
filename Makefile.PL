######################################################################
# Makefile.PL for Sys::Ramdisk
# 2010, Mike Schilli <cpan@perlmeister.com>
######################################################################
use ExtUtils::MakeMaker;
my $meta_merge = {
    META_MERGE => {
        resources => {
            repository => 'http://github.com/mschilli/sys-ramdisk-perl',
        },
    }
};
WriteMakefile(
    'NAME'         => 'Sys::Ramdisk',
    'VERSION_FROM' => 'lib/Sys/Ramdisk.pm', # finds $VERSION
    'PREREQ_PM'    => {
            'Log::Log4perl' => 0,
            'Sysadm::Install' => 0.44,
            'File::Temp' => 0,
    },
    $ExtUtils::MakeMaker::VERSION >= 6.50 ? (%$meta_merge) : (),
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Sys/Ramdisk.pm',
       AUTHOR     => 'Mike Schilli <cpan@perlmeister.com>') : (),
       LICENSE    => 'perl',
    ),
);
