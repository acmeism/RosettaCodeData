# 20240626 Raku programming solution

role MovieWatcherRole { has Str $.name;
   method WatchMovie() { say "$.name is watching the movie."   }
   method EatPopcorn() { say "$.name is enjoying the popcorn." }
}

class MovieWatcher does MovieWatcherRole {
   method new(Str $name) { self.bless(:$name) }
}

class ParentMovieWatcher is MovieWatcher { }

role ChildMovieWatcherRole {
   method EatPopcorn() { say "$.name is eating too much popcorn." }
}

class ChildMovieWatcher is MovieWatcher does ChildMovieWatcherRole { }

role YoungChildMovieWatcherRole {
   method WatchMovie() {
      say "Sorry, $.name, you are too young to watch the movie."
   }
}

class YoungChildMovieWatcher is ChildMovieWatcher does YoungChildMovieWatcherRole { }

for ParentMovieWatcher.new('Donald'),
    ChildMovieWatcher.new('Lisa'),
    YoungChildMovieWatcher.new('Fred')
{ .WatchMovie and .EatPopcorn }
