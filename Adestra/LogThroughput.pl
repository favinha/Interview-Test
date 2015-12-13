#! /usr/bin/perl

use Modern::Perl '2013';

my $log_file = $ARGV[0];
my $struct;

#Lets see if the a file was passed and the file is there
if ($log_file and -e $log_file) {
  say "Parsing $log_file";
  _ParseFile($log_file);
}
else {
  say "No file passed or I cant find it, exiting...";
  exit;
}


sub _ParseFile {
  my ($file) = @_;
  open(my $fh, "<", $file) or die "Cant open file $!";
  foreach my $line (<$fh>) {
    chomp $line;
    # Lets see if its a match
    next if $line !~ m/^\d{4}\/\d{2}\/\d{2}\s\d{2}\:\d{2}\:\d{2}/;
    # We split the line by spaces 
    my ($date, $time, @rest) = split (/\s/, $line);
    if (defined $struct->{$date.' '.$time}) {
      # If exists, then increment it
      $struct->{$date.' '.$time}++;
    }
    else {
      # Create a new one
      $struct->{$date.' '.$time} = 1;
    }
  }
  _PrintStruct($struct);
}


sub _PrintStruct {
  my ($struct) = @_;
  foreach my $key (sort {$a cmp $b} keys %$struct) {
    say $key, ": ", $struct->{$key}
  }
}
