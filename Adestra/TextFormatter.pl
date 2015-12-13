#! /usr/bin/perl

use Modern::Perl '2013';
use Getopt::Long;

my $length = 0;
my $help   = 1;
my $text   = { '1' => ''};

GetOptions ('help' => \$help, 'length=s' => \$length);
$help = 0 if ($length and ($length > 4));
help() if $help;

# Lets check if its all digits
if ($length =~ /^\d+$/g) {
  say "Limiting the text line to $length chars in length";
  _GetText($length);
}
else {
  help();
}

sub _GetText {
  my ($length) = @_;
  while (<STDIN>) {
    chomp $_;
    my @line = split /\s+/, $_;
    my $text = _FormatText($text, \@line);
    _ShowText($text);
  }
}

sub _FormatText {
  my ($text, $line) = @_;
  my $last_line = (sort {$a <=> $b} keys %$text)[-1];
  foreach my $word (@$line) {
    # lets see if the length of the word is bigger then the allowed line length
    if (length ($word) > $length) {
      # Replace the word with 'bla'
      $word = 'bla';
    }
    my $last_length = length($text->{$last_line});
    # If its bigger, we create another line
    if ($last_length + 1 + length($word) > $length ){
      $last_line++;
      $text->{$last_line} = $word;
    }
    else {
      $text->{$last_line} .= ' ' . $word;
    }
  }
  return $text;
}


sub _ShowText {
  my ($text) = @_;
  foreach my $pos (sort {$a <=> $b} keys %$text) {
    my $l = length($text->{$pos});
    say "$pos:$l \t", $text->{$pos};
  }
}

sub help {
  my $message = <<HELP_MESSAGE
This scripts accepts a integer as the length of the text lines and tries to format the text accordingly
Params:
--length 'number' - The number of caracters in length per line
HELP_MESSAGE
;
  say $message;
  exit;
}
