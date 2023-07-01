sub fulfill {
    my   @payloads;
    push @payloads, 'Payload#' . $_ for 0..5;
    my      @result;
    push    @result, ref $_ eq 'ARRAY' ? [@payloads[@$_]] : @payloads[$_] for @{@_[0]};
    return [@result];
}

sub formatted {
    my $result;
    $result .= ref $_ eq 'ARRAY' ? '[ "'. join('", "', @$_) . '" ], ' : qq{"$_"} for @{@_[0]};
    return '[ ' . $result . " ]\n";
}

print formatted fulfill( [[1,2], [ 3,4,1], 5] );
print formatted fulfill( [[1,2], [10,4,1], 5] );
