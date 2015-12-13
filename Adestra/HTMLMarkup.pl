#! /usr/bin/perl

use Modern::Perl '2013';
use Data::Dumper;

help();
my $markup = '';
my $struct = '';

while (<STDIN>) {
  last if $_ =~ /^_END$/g;
  $markup .= $_;
}

my $html = _ParseInput($markup);

sub _ParseInput {
  my ($markup) = @_;
  $markup =~ s/\n/__/g;
  $struct = _SplitLine($markup, $struct);  
  say "Final text :\n $struct";
}


# This is a very tricky subroutine. For maintenance purpose, it needs to be more clean / more comments
sub _SplitLine {
  my ($line, $struct) = @_;
  if ($line =~ /(\w+)\:(.+?)\}(.+)/) {
    my $text_loc = $2;
    #$text_loc =~ s/\}__/\n/;
    my $header = $1;
    if ($text_loc =~ /(\{\w+)\:/) { # Lets call it again
      $struct = _SplitLine($header.':'.$text_loc, $struct);
    }
    else {
      $struct = "<$header>$text_loc</$header>"; 
      $struct .= _SplitLine($3);
    }
  }
  elsif ($line =~ /(\w+)\:(.+)/) {
    my $text_loc = $2;
    my $header = $1;
    if ($text_loc =~ /(\{\w+)\:/) { # Lets call it again
      $struct = _SplitLine($text_loc, $struct);
    }
    # Lets undo the __
    $text_loc =~ s/__/\n/g;
    $text_loc =~ s/\}//;
    $text_loc =~ s/\{.+//;
    $struct = "<$header>$text_loc".($struct || '');
    $struct .= "</$header>";
  }
  return $struct;
}


sub help {
  my $message = <<HELP_MESSAGE
Write the text in the markup language and when finished, write '_END'
The software will then convert it to some sort of html
HELP_MESSAGE
;
  say $message;
}
