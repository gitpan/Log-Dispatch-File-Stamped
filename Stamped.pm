use strict;
package Log::Dispatch::File::Stamped;

use File::Basename        qw(fileparse);
use File::Spec::Functions qw(catfile);
use POSIX                 qw(strftime);

use vars qw(@ISA $VERSION);
use Log::Dispatch::File;
@ISA = qw(Log::Dispatch::File);

$VERSION = '0.01';

sub new
{
    my $proto = shift;
    my $class = ref $proto || $proto;

    my %params = @_;
    my $self = bless {}, $class;

    # stamp format
    $self->{stamp_fmt} = delete $params{stamp_fmt} || '%Y%m%d';
    
    # only append mode is supported
    $params{mode} = 'append';

    # base class initialization
    $self->_basic_init(%params);

    # split pathname into path, basename, extension
    @$self{qw(name path ext)} = fileparse($params{filename}, '\.[^.]+');

    return $self;
}
sub log_message
{
    my $self = shift;
    # might need to open a new file
    $self->_make_handle();
    # let the base class do the logging
    $self->SUPER::log_message(@_);
}
sub _make_stamp
{
    my $self = shift;
    # make stamp string from current date and time
    return strftime($self->{stamp_fmt}, localtime);
}
sub _make_handle
{
    my $self = shift;

    # make stamp string from current date and time
    my $stamp = $self->_make_stamp();

    # if the stamp string has changed, need to open a new logfile
    if (!$self->{stamp} || $stamp ne $self->{stamp}) {
        # build the stamped file name
        my $filename = join '-', $self->{name}, $stamp;
        $filename .= $self->{ext} if $self->{ext};
        $filename  = catfile($self->{path}, $filename);
        # close previous open logfile
        close $self->{fh} if $self->{fh};
        # open new logfile
        $self->SUPER::_make_handle(filename => $filename, mode => 'append');
    }
}

1;
__END__

=head1 NAME

Log::Dispatch::File::Stamped - Logging to date/time stamped files

=head1 SYNOPSIS

  use Log::Dispatch::File::Stamped;

  my $file = Log::Dispatch::File::Stamped->new(
    name      => 'file1',
    min_level => 'info',
    filename  => 'Somefile.log',
    stamp_fmt => '%Y%m%d',
    mode      => 'append' );

  $file->log( level => 'emerg', message => "I've fallen and I can't get up\n" );

=head1 DESCRIPTION

This module subclasses Log::Dispatch::File for logging to date/time
stamped files.

=head1 METHODS

=over 4

=item * new(%p)

This method takes the same set of parameters as Log::Dispatch::File::new(),
with the following differences:

=item -- filename ($)

The filename template. The actual timestamp will be appended to this filename
when creating the actual logfile. If the filename has an extension, the
timestamp is inserted before the extension. See examples below.

=item -- stamp_fmt ($)

The format of the timestamp string. This module uses POSIX::strftime to
create the timestamp string from the current local date and time.
Refer to your platform's strftime documentation for the list of allowed
tokens.

Defaults to '%Y%m%d'.

=item -- mode ($)

This parameter is ignored, and is forced to 'append'.

=back

=head1 EXAMPLES

Assuming the current date and time is:

  % perl -e 'print scalar localtime'
  Sat Feb  8 13:56:13 2003

  Log::Dispatch::File::Stamped->new(
    name      => 'file',
    min_level => 'debug',
    filename  => 'logfile.txt',
  );

This will log to file 'logfile-20030208.txt'.

  Log::Dispatch::File::Stamped->new(
    name      => 'file',
    min_level => 'debug',
    filename  => 'logfile.txt',
    stamp_fmt => '%d%H',
  );

This will log to file 'logfile-0813.txt'.

=head1 SEE ALSO

L<Log::Dispatch::File>, L<POSIX>.

=head1 AUTHOR

Eric Cholet <cholet@logilune.com>

=head1 COPYRIGHT

The Log::Dispatch::File::Stamped is free software. You may
distribute it under the terms of either the GNU General
Public License or the Artistic License, as specified in the
Perl README file.

=head1 ACKNOWLEDGEMENTS

Dave Rolsky, author of the Log::Dispatch suite and many other
fine modules on CPAN.

=cut

