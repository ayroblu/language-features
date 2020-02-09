use clap::{App, Arg};
// use regex::Regex;
use std::fs;
use std::fs::File;
use std::io::{self, prelude::*, BufReader};
use std::process::Command;

fn main() {
    println!("Hello, world!");
    let output = Command::new("ls")
        .args(&["-a"])
        .status()
        .expect("failed to execute process");
    println!("my files: {:?}", output);
    let contents =
        fs::read_to_string("./rust/README.md").expect("Something went wrong reading the file");
    println!("file contents: {}", contents);
    arg_parse();
}
fn arg_parse() {
    let matches = App::new("language-features-helper")
        .version("0.1.0")
        .author("Ben Lu <ayroblu@gmail.com>")
        .about("Language features helper function")
        .arg(
            Arg::with_name("filepath")
                .required(true)
                .takes_value(true)
                .index(1)
                .help("Markdown file to modify"),
        )
        .get_matches();
    let filepath = matches.value_of("filepath").unwrap();
    println!("filepath: {}", filepath);
    let res = parse_file(filepath);
    match res {
        Ok(()) => println!("Done"),
        Err(error) => println!("Problem opening the file: {:?}", error),
    };
}
fn parse_file(filename: &str) -> io::Result<()> {
    let f = File::open(filename)?;
    let f = BufReader::new(f);

    for line in f.lines() {
        println!("{}", line.unwrap());
    }
    // let contents = fs::read_to_string(filepath).expect("Something went wrong reading the file");
    // println!("file contents: {}", contents);
    // let re = Regex::new(r"\n```rust\n.*?\n```\b").unwrap();
    // assert!(re.is_match(&contents));
    return Ok(());
}
