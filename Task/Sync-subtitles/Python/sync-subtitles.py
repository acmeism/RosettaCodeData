#! /usr/bin/env python3

import datetime

def add_seconds(time_str, secs):
    time_format = "%H:%M:%S,%f"
    time_obj = datetime.datetime.strptime(time_str, time_format)
    delta = datetime.timedelta(seconds=secs)
    new_time_obj = time_obj + delta
    new_time_str = new_time_obj.strftime(time_format)[:-3]  # remove the last 3 digits of microseconds
    return new_time_str

def sync_subtitles(file_in, file_out, secs):
    with open(file_in, 'r') as fin, open(file_out, 'w') as fout:
        for line in fin:
            if '-->' in line:
                start_time, end_time = line.strip().split(' --> ')
                start_time = add_seconds(start_time, secs)
                end_time = add_seconds(end_time, secs)
                fout.write(f"{start_time} --> {end_time}\n")
            else:
                fout.write(line)

print("After fast-forwarding 9 seconds:\n")
sync_subtitles("movie.srt", "movie_corrected.srt", 9)
with open("movie_corrected.srt", 'r') as f:
    print(f.read())

print("\n\nAfter rolling-back 9 seconds:\n")
sync_subtitles("movie.srt", "movie_corrected2.srt", -9)
with open("movie_corrected2.srt", 'r') as f:
    print(f.read())
