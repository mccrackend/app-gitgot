#! perl

use autodie;
use strict;
use warnings;

use lib 't/lib';
use Test::BASE;
use Test::More;

use App::Cmd::Tester;
use App::GitGot;

my( $config , $dir ) = Test::BASE::write_fake_config();

$ENV{GITGOT_FAKE_GIT_WRAPPER} = 1;

{
  my $result = test_app( 'App::GitGot' => [ 'push' , '-f' , $config , '-C' ]);

  like $result->stdout    , qr|1\)\s+bar\.git\s+\:\s+Nothing to push| , 'repo 1';
  like $result->stdout    , qr|2\)\s+bargle\.git\s+\:\s+Nothing to push| , 'repo 2';
  is   $result->stderr    , '' , 'nothing on STDERR';
  is   $result->exit_code , 0  , 'exit with 0';
}

{
  my $result = test_app( 'App::GitGot' => [ 'push' , '-f' , $config , '-C' , '-q' ]);

  is $result->stdout    , '' , 'nothing on STDOUT';
  is $result->stderr    , '' , 'nothing on STDERR';
  is $result->exit_code , 0  , 'exit with 0';
}

chdir(); ## let File::Temp clean up...
done_testing();
