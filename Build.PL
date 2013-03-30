use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name    => 'Test::JSYNC',
    license        => 'perl',
    create_license => 1,
    create_readme  => 1,
    configure_requires => {
        'Module::Build' => 0.36,
    },
    build_requires => {
        'warnings'     => 0,
        'Test::More'   => 0.41,  # diag()
        'Test::Tester' => 0.107,
    },
    requires => {
        'perl'              => '5.6.0',
        'parent'            => 0,
        'strict'            => 0,
        'utf8'              => 0,
        'JSYNC'             => 0,
        'Test::Differences' => 0.47,
    },
    meta_merge => {
        resources => {
            repository => 'git://github.com/patch/test-jsync-pm5.git',
            homepage   => 'https://github.com/patch/test-jsync-pm5',
            bugtracker => 'https://github.com/patch/test-jsync-pm5/issues',
        },
    },
);

$builder->create_build_script;
