#!/usr/bin/env run-cargo-script
//! ```cargo
//! [dependencies]
//! regex = "1"
//! anyhow = "1"
//! ```

use anyhow::{bail, Context, Result};
extern crate anyhow;
extern crate regex;
use regex::Regex;
use std::env;
use std::fs;
use std::process::Command;

struct ScriptConfig {
    hyprland_monitor_config_file_path: String,
    monitor_line_regex: Regex,
    toggle_suffix: String,
}

impl ScriptConfig {
    fn new() -> Result<Self> {
        let home_dir = env::var("HOME").context("HOME environment variable not set")?;
        Ok(ScriptConfig {
            hyprland_monitor_config_file_path: format!("{}/.config/hypr/UserConfigs/Monitors.conf", home_dir),
            monitor_line_regex: Regex::new(r"^monitor=desc:Philips Consumer Electronics Company Philips FTV 0x01010101,preferred,auto-right,1")
                .context("Failed to compile the monitor line regex")?,
            toggle_suffix: ",mirror,DP-3".to_string(),
        })
    }
}

fn run(script_config: &ScriptConfig) -> Result<()> {
    let data = fs::read_to_string(&script_config.hyprland_monitor_config_file_path)
        .context("Failed to read the configuration file")?;
    let mut modified = false;

    let lines: Vec<String> = data
        .lines()
        .map(|line| {
            if script_config.monitor_line_regex.is_match(line) {
                modified = true;
                if line.contains(&script_config.toggle_suffix) {
                    line.replace(&script_config.toggle_suffix, "")
                } else {
                    format!("{}{}", line, script_config.toggle_suffix)
                }
            } else {
                line.to_string()
            }
        })
        .collect();

    if modified {
        fs::write(
            &script_config.hyprland_monitor_config_file_path,
            lines.join("\n") + "\n",
        )
        .context("Failed to write updates to the configuration file")?;
        println!("Configuration updated successfully.");
    } else {
        println!("No changes needed.");
    }

    Ok(())
}

fn notify(message: &str) -> Result<()> {
    Command::new("hyprctl")
        .args(["notify", "-1", "10000", "rgb(ff1ea3)", message])
        .output()
        .context("Failed to send notification")?;
    Ok(())
}

fn main() -> Result<()> {
    let config = ScriptConfig::new()?;
    if let Err(err) = run(&config) {
        eprintln!("An error occurred: {}", err);
        notify(&format!("An error occurred during script execution: {err}",))?;
    }
    Ok(())
}
