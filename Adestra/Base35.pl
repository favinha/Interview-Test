#! /usr/bin/perl -w

#use Modern::Perl '2013';
use v5.18;
use Getopt::Long;
use Math::BaseCalc;
use Base35::To;
use Base35::From;

my $calc35 = new Math::BaseCalc(digits=>[0..9,'A'..'Y']);

my $from = 0;
my $to = 0;
my $help = 1;
# Script to convert numbers to and from a base35 

GetOptions ('help' => \$help, 'from=s' => \$from, 'to=s' => \$to);
$help = 0 if ($from || $to);

help() if $help;
to($to) if $to;
from($from) if $from;
# 

sub to {
  my ($number) = @_;
  my $base35 = Base35::To->new(number => $number);
  say "The result from converting decimal '$number' to base35 is";
  say "\t", $base35->Convert;
  #Just to check if its ok
  #say "\t", $calc35->to_base($number);
}

sub from {
  my ($number) = @_;
   my $base35 = Base35::From->new(number => $number);
  say "The result from converting base35 '$number' to decinal is";
  say "\t", $base35->Convert;
  #Just to check if its ok
  #say "\t", $calc35->from_base($number);
}


sub help {
  my $message = <<HELP_MESSAGE
This scripts converts a number to a base 35 OR convert from a base 35 to a decimal base
Params:
--to 'number' - converts to base35
--from' base35' - converts to decimal number
--help - Prints this help message
HELP_MESSAGE
;
  say $message;  
}


