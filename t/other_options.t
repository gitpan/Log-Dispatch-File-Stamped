use strict;
use warnings FATAL => 'all';

use Test::More 0.88;
use Test::TempDir;
use Test::Deep;
use Path::Tiny;
use Log::Dispatch;

my $dir = temp_root;

{
    my $logger = Log::Dispatch->new(
        outputs => [ [
            'File::Stamped',
            name => 'foo',
            min_level => 'debug',
            filename => path($dir, 'foo.log')->stringify,
            binmode => ':utf8',
            autoflush => 0,
            close_after_write => 1,
            permissions => '0777',
            syswrite => 1,
        ] ],
    );

    my $output = $logger->output('foo');

    cmp_deeply(
        $logger->output('foo'),
        noclass(superhashof({
            name => 'foo',
            min_level => '0',
            max_level => '7',
            binmode => ':utf8',
            autoflush => 0,
            close => 1,
            permissions => '0777',
            syswrite => 1,
            mode => '>>',
        })),
        'all Log::Dispatch::File options are preserved in the logger output',
    );
}

done_testing;
