package Test::BrewBuild::Plugin::TestAgainst;

use 5.006;
use strict;
use warnings;

package Test::BrewBuild::Plugin::TestAgainst;

our $VERSION = '0.02';

my $module;

sub brewbuild_exec{
    shift if ref $_[0];
    $module = shift;
    return _cmd($module);
}    
sub _cmd {
    my $module = shift;

    my @cmd = <DATA>;
    for (@cmd){
        s/%\[MODULE\]%/$module/g;
    }

    return @cmd;
}    

1;

=head1 NAME

Test::BrewBuild::Plugin::TestAgainst - Test external modules against current
builds of the one being tested

=head1 SYNOPSIS

    brewbuild --plugin Test::BrewBuild::Plugin::TestAgainst --args Rev::Dep

=head1 DESCRIPTION

This is a plugin for L<Test::BrewBuild>. The plugin sub takes the name of a
module, and after testing and installing of the revision of the local module, 
it'll run the test suite of the external module to ensure it passes with the
current prerequisite codebase.

Useful mainly for testing reverse dependencies of the module you're currently
working on.

=head1 FUNCTIONS

=head2 brewbuild_exec($module_name);

Takes the name of the module, and returns back the appropriate configuration
commands to L<Test::Brewbuild>.

=head1 AUTHOR

Steve Bertrand, C<< <steveb at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Same as L<Test::BrewBuild>

=cut

__DATA__
if ($^O eq 'MSWin32'){
    my $make = -e 'Makefile.PL' ? 'dmake' : 'Build';
    system "cpanm --installdeps . && cpanm . && cpanm --test-only %[MODULE]%";
}
else {
    system "cpanm --installdeps . && cpanm . && cpanm --test-only %[MODULE]%";
}
