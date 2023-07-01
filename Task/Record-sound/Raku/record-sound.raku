use Audio::PortAudio;
use Audio::Sndfile;

sub MAIN(Str $filename, Str :$source, Int :$buffer = 256) {
    my $pa = Audio::PortAudio.new;
    my $format = Audio::Sndfile::Info::Format::WAV +| Audio::Sndfile::Info::Subformat::PCM_16;
    my $out-file = Audio::Sndfile.new(:$filename, channels => 1, samplerate => 44100, :$format, :w);
    my $st;

    if $source.defined {
        my $index = 0;
        for $pa.devices -> $device {
            if $device.name eq $source {
                else {
                    my $la = $device.default-high-input-latency;
                    my $si = Audio::PortAudio::StreamParameters.new(device => $index,
                                                                    channel-count => 1,
                                                                    sample-format => Audio::PortAudio::StreamFormat::Float32,
                                                                    suggested-latency => ($la || 0.05e0 ));
                    $st = $pa.open-stream($si, Audio::PortAudio::StreamParameters, 44100, $buffer );
                    last;
                }

            }
            $index++;
        }
        die "Couldn't find a device for '$source'" if !$st.defined;
    }
    else {
        $st = $pa.open-default-stream(2,0, Audio::PortAudio::StreamFormat::Float32, 44100, $buffer);
    }
    $st.start;
    my $p = Promise.new;
    signal(SIGINT).act({
        say "stopping recording";
        $p.keep: "stopped";
        $out-file.close;
        $st.close;
        exit;
    });
    my Channel $write-channel = Channel.new;
    my $write-promise = start {
        react {
            whenever $write-channel -> $item {
                if $p.status ~~ Planned {
                    $out-file.write-float($item[0], $item[1]);
                    $out-file.sync;
                }
                else {
                    done;
                }
            }
        }
    };

    loop {
        if $p.status ~~ Planned {
            my $f = $buffer || $st.read-available;
            if $f > 0 {
                my $buff = $st.read($f,2, num32);
                $write-channel.send([$buff, $f]);
            }
        }
        else {
            last;
        }
    }

}
