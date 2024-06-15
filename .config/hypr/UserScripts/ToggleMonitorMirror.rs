#!/usr/bin/env run-cargo-script
//! ```cargo
//! [dependencies]
//! regex = "1"
//! ```

extern crate regex;
use regex::Regex;
use std::io::{self, Write};
use std::{env, fs};

fn main() -> io::Result<()> {
    let home_dir = env::var("HOME").expect("HOME environment variable not set");
    let file_path = format!("{}/.config/hypr/UserConfigs/Monitors.conf", home_dir);
    let data = fs::read_to_string(&file_path)?;

    let monitor_line_regex = Regex::new(r"^monitor=desc:Philips Consumer Electronics Company Philips FTV 0x01010101,preferred,auto-right,1").expect("Expected to find correct monitor");
    let toggle_suffix = ",mirror,DP-3";
    let mut modified = false;

    let lines: Vec<String> = data
        .lines()
        .map(|line| {
            if monitor_line_regex.is_match(line) {
                modified = true;
                if line.contains(toggle_suffix) {
                    line.replace(toggle_suffix, "")
                } else {
                    format!("{}{}", line, toggle_suffix)
                }
            } else {
                line.to_string()
            }
        })
        .collect();

    if modified {
        fs::write(&file_path, lines.join("\n") + "\n")?;
        println!("Configuration updated successfully.");
    } else {
        println!("No changes needed.");
    }

    Ok(())
}
