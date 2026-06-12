    method delete ($value --> Cell) {
        my $prev = Nil;
        my $cell = self;
        my $new-head = self;

        while $cell {
            my $next = $cell.next;
            if $cell.value == $value {
                $prev.next = $next if $prev;
                $cell.next = Nil;
                $new-head = $next if $cell === $new-head;
            }
            else {
                $prev = $cell;
            }
            $cell = $next;
        }

        return $new-head;
    }
