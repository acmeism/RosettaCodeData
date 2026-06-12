use bitflags::bitflags;

bitflags! {
    pub struct RedactOptions: u8 {
        const NoOptions = 0;
        const WholeWord = 1;
        const Overkill = 2;
        const CaseInsensitive = 4;
    }
}

fn is_word_char(ch: &char) -> bool {
    return ch == &'-' || ch.is_alphabetic();
}

// Performs in-place redaction of the target with the specified options.
fn redact(text: &mut String, target: &str, options: &RedactOptions) {
    let target_length = target.len();
    if target_length == 0 {
        return;
    }
    let mut start_pos = 0;
    let end_pos = text.len();
    while start_pos < end_pos {
        let search_pos = if options.contains(RedactOptions::CaseInsensitive) {
            text[start_pos..]
                .to_ascii_lowercase()
                .find(&target.to_ascii_lowercase())
        } else {
            text[start_pos..].find(&target)
        };
        if search_pos == None {
            break;
        }
        let pos = search_pos.unwrap() + start_pos;
        let mut word_start = pos;
        let mut word_end = word_start + target_length;
        if options.intersects(RedactOptions::Overkill | RedactOptions::WholeWord) {
            let textchars: Vec<char> = text.chars().collect();
            while word_start > start_pos && is_word_char(&textchars[word_start - 1]) {
                word_start -= 1;
            }
            while word_end < end_pos && is_word_char(&textchars[word_end]) {
                word_end += 1;
            }
        }
        if !options.contains(RedactOptions::WholeWord)
            || (word_start == pos && word_end == pos + target_length)
        {
            text.replace_range(word_start..word_end, &"X".repeat(word_end - word_start));
        }
        start_pos = word_end;
    }
}

fn do_basic_test(target: &str, options: RedactOptions) {
    let mut text = String::new()
        + "Tom? Toms bottom tomato is in his stomach while playing the "
        + "\"Tom-tom\" brand tom-toms. That's so tom.";
    redact(&mut text, target, &options);
    println!(
        "[{}|{}|{}]: {}",
        if options.contains(RedactOptions::WholeWord) {
            'w'
        } else {
            'p'
        },
        if options.contains(RedactOptions::CaseInsensitive) {
            'i'
        } else {
            's'
        },
        if options.contains(RedactOptions::Overkill) {
            'o'
        } else {
            'n'
        },
        text
    );
}

fn do_tests(target: &str) {
    println!("Redact '{}':", target);
    do_basic_test(target, RedactOptions::WholeWord);
    do_basic_test(
        target,
        RedactOptions::WholeWord | RedactOptions::CaseInsensitive,
    );
    do_basic_test(target, RedactOptions::NoOptions);
    do_basic_test(target, RedactOptions::CaseInsensitive);
    do_basic_test(target, RedactOptions::Overkill);
    do_basic_test(
        target,
        RedactOptions::CaseInsensitive | RedactOptions::Overkill,
    );
}

fn main() {
    do_tests("Tom");
    println!();
    do_tests("tom");
    return ();
}
