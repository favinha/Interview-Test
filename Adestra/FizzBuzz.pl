#! /usr/bin/perl -w

use Modern::Perl '2013';

# Script to checkif the number is a multiple of 3, 5 or both

for my $number (1 .. 100) {
  if (($number % 3) == 0) { #If its a multiple of 3
    my $output = ($number % 5) == 0 ? 'FizzBuzz' : 'Fizz'; # Check if its also a multiple of 5
    say $output ;
  }
  elsif (($number % 5) == 0) { # Check if its a multiple of 5
    say "Buzz";
  }
  else { # Otherwise, just say the number!
    say "$number";
  }
}



