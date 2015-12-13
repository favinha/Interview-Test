#! /usr/bin/perl -w

### Lets create a game

use v5.18;

use Game;

my $game = Game->new('num_players' => 4);  ## For now, its going to be HAL9000 VS DeepBlue ...

$game->start();

1;


