<?php

$swallowed = array(
  array('swallowed' => 'fly.',
        'reason' => "I don't know why she swallowed the fly."),
  array('swallowed' => 'spider,',
        'aside' => "which wiggled and jiggled and tickled inside her.",
        'reason' => "She swallowed the spider to catch the fly"),
  array('swallowed' => 'bird.',
        'aside' => "How absurd! To swallow a bird!",
        'reason' => "She swallowed the bird to catch the spider,"),
  array('swallowed' => 'cat.',
        'aside' => "Imagine that! To swallow a cat!",
        'reason' => "She swallowed the cat to catch the bird."),
  array('swallowed' => 'dog.',
        'aside' => "What a hog! To swallow a dog!",
        'reason' => "She swallowed the dog to catch the cat."),
  array('swallowed' => 'horse',
        'aside' => "She's dead, of course. She swallowed a horse!",
        'reason' => "She swallowed the horse to catch the dog."));

foreach($swallowed as $creature)
{
  print "I knew an old lady who swallowed a " . $creature['swallowed'] . "\n";
  if(array_key_exists('aside', $creature))
    print $creature['aside'] . "\n";

  $reversed = array_reverse($swallowed);
  $history = array_slice($reversed, array_search($creature, $reversed));

  foreach($history as $note)
  {
    print $note['reason'] . "\n";
  }

  if($swallowed[count($swallowed) - 1] == $creature)
    print "But she sure died!\n";
  else
    print "Perhaps she'll die." . "\n\n";
}
