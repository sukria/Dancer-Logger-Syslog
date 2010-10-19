package Dancer::Logger::Syslog;

use strict;
use warnings;

use vars '$VERSION';
use base 'Dancer::Logger::Abstract';
use File::Basename 'basename';
use Sys::Syslog qw(:DEFAULT setlogsock);

use Dancer::Config 'setting';

$VERSION = '0.2';

sub init {
    my ($self) = @_;
    my $basename = setting('appname') || $ENV{DANCER_APPDIR} || basename($0);
    setlogsock('unix');
    openlog($basename, 'pid', 'USER');
}

sub DESTROY { closelog() }

# our format should be a bit cooked for syslog
sub format_message {
    my ($self, $level, $message) = @_;
    chomp $message;

    my ($package, $file, $line) = caller(3);
    $package ||= '-';
    $file    ||= '-';
    $line    ||= '-';

    my $time = Dancer::SharedData->timer->tick;
    my $r    = Dancer::SharedData->request;
    if (defined $r) {
        return "\@$time> [hit #" . $r->id . "] $message in $file l. $line\n";
    }
    else {
        return "\@$time> $message in $file l. $line\n";
    }
}

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

=head2 format_message()

This method defines how to format messages for Syslog, it's a bit different 
than the standard one provided by L<Dancer::Logger::Abstract> because Syslog
already provides a couple of information.

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
