package Dancer::Logger::Syslog;

use strict;
use warnings;

use vars '$VERSION';
use base 'Dancer::Logger::Abstract';
use File::Basename 'basename';
use Sys::Syslog qw(:DEFAULT setlogsock);

$VERSION = '0.2';

sub init {
    my ($self) = @_;
    my $basename = basename($0);
    setlogsock('unix');
    openlog($basename, 'pid', 'USER');
}

sub DESTROY { closelog() }

sub _log {
    my ($self, $level, $message) = @_;
    my $syslog_levels = {
        core    => 'debug',
        debug   => 'debug',
        warning => 'warning',
        error   => 'err',
    };
    $level = $syslog_levels->{$level} || 'debug';
    my $fm = $self->format_message($level => $message);
    return syslog($level, $fm);
}

1;
__END__

=pod

=head1 NAME

Dancer::Logger::Syslog - Dancer logger engine for Sys::Syslog

=head1 DESCRIPTION

This module implements a logger engine that send log messages to syslog,
through the Sys::Syslog module.

=head1 CONFIGURATION

The setting B<logger> should be set to C<syslog> in order to use this session
engine in a Dancer application.

=head1 METHODS

=head2 init()

The init method is called by Dancer when creating the logger engine
with this class. It will initiate a Syslog connection under the B<USER>
facility.

=head1 DEPENDENCY

This module depends on L<Sys::Syslog>.

=head1 AUTHOR

This module has been written by Alexis Sukrieh

=head1 SEE ALSO

See L<Dancer> for details about logging in route handlers.

=head1 COPYRIGHT

This module is copyright (c) 2010 Alexis Sukrieh <sukria@sukria.net>.

=head1 LICENSE

This module is free software and is released under the same terms as Perl
itself.

=cut
