#!/usr/bin/env run-cargo-script
//! ```cargo
//! [package]
//! edition = "2021"
//! [dependencies]
//! regex = "1"
//! anyhow = "1"
//! clap = "3"
//! serde = {version = "1", features = ["derive"] }
//! serde_json = "1"
//! tokio = { version = "1", features = ["full"] }
//! ```

use anyhow::{bail, Context, Result};
extern crate anyhow;
extern crate regex;
use regex::Regex;
use std::env;
use std::fs;

use clap::{App, Arg};
use serde_json::Value;
use std::process::Command;

#[tokio::main]
async fn main() -> Result<()> {
    let matches = App::new("Hyprland Window Focuser")
        .version("0.1")
        .author("Liam Woodleigh-Hardinge")
        .about("Focuses windows and launches applications in Hyprland")
        .arg(
            Arg::with_name("client")
                .short('c')
                .long("client")
                .takes_value(true)
                .help("The client application class name"),
        )
        .arg(
            Arg::with_name("launcher")
                .short('l')
                .long("launcher")
                .takes_value(true)
                .help("The command to launch the client if not running"),
        )
        .get_matches();

    let client_name = matches.value_of("client").unwrap_or("default_client");
    let launcher_command = matches.value_of("launcher").unwrap_or("");

    manage_windows(client_name, launcher_command).await
}

async fn manage_windows(client_name: &str, launcher_command: &str) -> Result<()> {
    let clients_json = Command::new("hyprctl")
        .args(["clients", "-j"])
        .output()
        .context("Failed to get client list from hyprctl")?
        .stdout;

    let clients: Value =
        serde_json::from_slice(&clients_json).context("Failed to parse clients JSON")?;

    let open_windows_for_this_client: Vec<Value> = clients
        .as_array()
        .unwrap_or(&vec![])
        .iter()
        .filter(|client| client["class"] == client_name)
        .cloned()
        .collect();

    let num_windows = open_windows_for_this_client.len();

    if num_windows > 0 {
        let active_window_address = Command::new("hyprctl")
            .args(["activewindow", "-j"])
            .output()
            .context("Failed to get active window from hyprctl")?
            .stdout;

        let active_window: Value = serde_json::from_slice(&active_window_address)
            .context("Failed to parse active window JSON")?;
        let active_address = active_window["address"].as_str().unwrap_or("");

        if num_windows > 1 {
            if let Some(different_window) = open_windows_for_this_client
                .iter()
                .filter(|window| window["address"].as_str() != Some(active_address))
                .max_by_key(|window| window["focusHistoryID"].as_i64().unwrap_or(0))
            {
                let diff_address = different_window["address"].as_str().unwrap_or("");
                Command::new("hyprctl")
                    .args(["dispatch", &format!("focuswindow address:{}", diff_address)])
                    .output()
                    .context("Failed to focus different window")?;
            }
        } else {
            let window_address = open_windows_for_this_client
                .first()
                .and_then(|window| window["address"].as_str())
                .unwrap_or("");

            if window_address != active_address {
                Command::new("hyprctl")
                    .args([
                        "dispatch",
                        &format!("focuswindow address:{}", window_address),
                    ])
                    .output()
                    .context("Failed to focus single window")?;
            }
        }
    } else {
        if !launcher_command.is_empty() {
            Command::new("sh")
                .arg("-c")
                .arg(launcher_command)
                .spawn()
                .context("Failed to launch the application")?;
        }
    }

    Ok(())
}
