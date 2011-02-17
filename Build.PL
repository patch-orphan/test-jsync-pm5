use strict;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'Test::JSYNC',
    license           => 'perl',
    dist_author       => 'Curtis "Ovid" Poe <ovid@cpan.org>',
    dist_version_from => 'lib/Test/JSYNC.pm',
    requires          => {
        'JSYNC'             => 0,
        'Test::Differences' => 0.47,
        'Test::Simple'      => 0.62,
        'Test::Tester'      => 0.107,
    },
    add_to_cleanup     => ['Test-JSYNC-*'],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
